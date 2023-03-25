//go:build windows
// +build windows

package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"

	"github.com/dbathgate/windowsfontloader/fontloader"
)

func main() {
	fmt.Println("Hello World")

	err, fl := fontloader.New()
	checkErr(err)

	defer syscall.FreeLibrary(fl.FontHandle)
	checkErr(fl.Load("C:\\Windows\\Fonts"))

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	<-c

}

func checkErr(err error) {
	if err != nil {
		fmt.Fprintf(os.Stderr, "\n%s\n", err)
		os.Exit(1)
	}
}
