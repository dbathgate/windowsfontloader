package fontloader

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"syscall"
	"unsafe"
)

type FontLoader struct {
	FontHandle syscall.Handle
}

func New() (error, *FontLoader) {
	gdi32, err := syscall.LoadLibrary(os.ExpandEnv(`${windir}\system32\gdi32.dll`))

	if err != nil {
		return err, nil
	}

	return nil, &FontLoader{
		FontHandle: gdi32,
	}
}

func (f *FontLoader) Load(fontDirectory string) error {
	fonts, err := ioutil.ReadDir(fontDirectory)

	if err != nil {
		return err
	}

	addFontResource, _ := syscall.GetProcAddress(f.FontHandle, "AddFontResourceW")

	fmt.Println("Loading fonts...")

	for _, font := range fonts {
		fullPath, err := filepath.Abs(filepath.Join(fontDirectory, font.Name()))

		if err != nil {
			return err
		}

		fmt.Println("Adding Font: " + fullPath)

		var nargs uintptr = 1
		r1, _, exitCode := syscall.Syscall(uintptr(addFontResource),
			nargs,
			uintptr(unsafe.Pointer(syscall.StringToUTF16Ptr(fullPath))),
			0,
			0,
		)

		if r1 == 0 {
			fmt.Println("Failed to load font " + font.Name() + ", " + exitCode.Error())
		}
	}

	return nil
}
