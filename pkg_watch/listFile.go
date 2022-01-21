package main

import (
    "os"
    "flag"
    "log"
    "strings"
    "regexp"
    "path/filepath"
    "gopkg.in/ini.v1"
    //"github.com/go-ini/ini"
)

func main() {

	// process arguments
	cmdPtr := flag.String("cmd", "pkg_list", "command to p/rforr")
	repoPtr := flag.String("repo", "./", "path of source code repositroy")
	targetPtr := flag.String("target", "linux", "platform e.g. linux, linux2, windows")

	flag.Parse()

	// create logfile
	/*logfile := os.Args[0] + ".log"
	file, err := os.OpenFile(logfile, os.O_CREATE|os.O_APPEND|os.O_RDWR, 0644)
	if (err != nil) {
		log.Fatal(err)
	}

	log.SetOutput(file)
	*/

	log.Println("INFO log Start")
	log.Printf("INFO path of repository [%s] \n", *repoPtr)
	log.Printf("INFO platform target [%s] \n", *targetPtr)

	if (strings.Compare(*cmdPtr, "pkg_list") == 0) {
		var list, err = getPlanfileList(*repoPtr)
		if (err != nil) {
			log.Printf("ERR unable to get planfiles [%s] \n", err)
		}

		getPackageData(list)

	} else {
		log.Println("ERR invalid command")
	}
}

func getPlanfileList(dirpath string) ([]string, error) {
	var files []string

	// get list of all planfile (plan.sh & plan.ps1) present in directory
	err := filepath.Walk(dirpath,
		func(path string, info os.FileInfo, err error) error {
			var r, _ = regexp.Compile("plan\\.sh|plan\\.ps1")
			if (info.IsDir() == false && r.MatchString(path) == true) {
				// remove deprecated, test planfiles
				if(strings.Contains(path, ".deprecated") == false) {
					files = append(files, path)
				}
			}
			return nil
		})

	return files, err
}

func getPackageData(list []string) {
	// read planfile and fetch plan meta data
	for _, element := range list {
		var cfg, err = ini.LoadSources(ini.LoadOptions{
			SkipUnrecognizableLines: true,
			}, element)

		if (err != nil) {
			log.Printf("ERR fail to load planfile [%s], err[%s] \n", element, err)
		}

		// list of parameters to be read from planfile
		var key = ""
		var param = [4]string{"pkg_origin", "pkg_name", "pkg_version", "pkg_source"}

		for _, key = range param {
			if(strings.Contains(element, "plan.ps1") == true) {
				key = "$" + key
			}

			// Classic read of values, default section can be represented as empty string
			log.Printf("[%s] [%s] \n", key, cfg.Section("").Key(key).String())
		}

		log.Printf("planfile [%s] \n", element)
	}
}
