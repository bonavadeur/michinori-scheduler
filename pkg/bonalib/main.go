package bonalib

import (
	"math/rand"
	"strconv"

	// "log"
	"github.com/davecgh/go-spew/spew"
	// "log"
	"fmt"
)

func Baka() string {
	return "Baka"
}

func RandNumber() string {
	return strconv.Itoa(rand.Intn(1000))
}

// 1;31: red
// 1;32: green
// 1;33: yellow
// 1;34: blue
// 1;35: purple

func Log(msg string, obj interface{}) {
	if msg == "" {
		msg = "-"
	}
	if obj == "" {
		obj = "-"
	}
	color := "\033[1;33m%v\033[0m" // yellow
	str := spew.Sprintln("0---bonaLog", msg, obj)
	fmt.Printf(color, str)
	color = "\033[0m%v\033[0m" // reset
	fmt.Printf(color, "\n")
}

func Succ(msg string, obj interface{}) {
	if msg == "" {
		msg = "-"
	}
	if obj == "" {
		obj = "-"
	}
	color := "\033[1;32m%v\033[0m" // yellow
	str := spew.Sprintln("0---bonaLog", msg, obj)
	fmt.Printf(color, str)
	color = "\033[0m%v\033[0m" // reset
	fmt.Printf(color, "\n")
}

func Warn(msg string, obj interface{}) {
	if msg == "" {
		msg = "-"
	}
	if obj == "" {
		obj = "-"
	}
	color := "\033[1;31m%v\033[0m" // yellow
	str := spew.Sprintln("0---bonaLog", msg, obj)
	fmt.Printf(color, str)
	color = "\033[0m%v\033[0m" // reset
	fmt.Printf(color, "\n")
}

func Info(msg string, obj interface{}) {
	if msg == "" {
		msg = "-"
	}
	if obj == "" {
		obj = "-"
	}
	color := "\033[1;34m%v\033[0m" // yellow
	str := spew.Sprintln("0---bonaLog", msg, obj)
	fmt.Printf(color, str)
	color = "\033[0m%v\033[0m" // reset
	fmt.Printf(color, "\n")
}

func Vio(msg string, obj interface{}) {
	if msg == "" {
		msg = "-"
	}
	if obj == "" {
		obj = "-"
	}
	color := "\033[1;35m%v\033[0m" // yellow
	str := spew.Sprintln("0---bonaLog", msg, obj)
	fmt.Printf(color, str)
	color = "\033[0m%v\033[0m" // reset
	fmt.Printf(color, "\n")
}

func Line() {
	fmt.Printf("\n\n\n")
}

func Logln(msg string, obj interface{}) {
	// 32: green 33: yellow
	if msg == "" {
		msg = "-"
	}
	if obj == "" {
		obj = "-"
	}
	color := "\033[1;33m%v\033[0m" // yellow
	str := spew.Sprintln("0---bonaLog", msg, obj)
	fmt.Printf(color, str)
	color = "\033[0m%v\033[0m" // reset
	fmt.Printf(color, "-------------------------------\n\n")
}
