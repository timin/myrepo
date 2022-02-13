package main

import (
    "os"
    "flag"
    "log"
    "strings"
    "regexp"
    "path/filepath"
    "gopkg.in/ini.v1"
    "encoding/json"
    "io/ioutil"
)

func main() {

	// process arguments
	cmdPtr := flag.String("cmd", "inventory", "command/action to perform e.g. inventory,")
	repoPtr := flag.String("repo", "./", "path of source code repositroy")
	targetPtr := flag.String("target", "linux", "platform e.g. linux, windows, all")

	flag.Parse()

	// create logfile
	/*logfile := os.Args[0] + ".log"
	file, err := os.OpenFile(logfile, os.O_CREATE|os.O_APPEND|os.O_RDWR, 0644)
	if (err != nil) {
		log.Fatal(err)
	}

	log.SetOutput(file)
	*/

	log.Println("INFO log start")
	log.Printf("INFO command [%s] \n", *cmdPtr)
	log.Printf("INFO path of repository [%s] \n", *repoPtr)
	log.Printf("INFO platform target [%s] \n", *targetPtr)

	if (strings.Compare(*cmdPtr, "inventory") == 0) {
		// get list of planfiles from repo
		var list, err = getPlanfileList(*repoPtr, *targetPtr)
		if (err != nil) {
			log.Printf("ERR unable to get planfiles [%s] \n", err)
		}

		// get parameter from planfile
		getPackageData(list, *repoPtr)

	} else {
		log.Println("ERR invalid command")
	}

	log.Println("INFO log stop")
}

func getPlanfileList(dirpath, target string) ([]string, error) {
	var files []string

	// get list of all planfile (plan.sh & plan.ps1) present in directory
	err := filepath.Walk(dirpath,
		func(path string, info os.FileInfo, err error) error {
			// skip ".deprecated" directory
			if (info.IsDir() == true && info.Name() == ".deprecated") {
				return filepath.SkipDir
			}

			var r *regexp.Regexp

			if (target == "linux") {
				r, _ = regexp.Compile("plan\\.sh")
			} else if (target == "windows") {
				r, _ = regexp.Compile("plan\\.ps1")
			} else {
				r, _ = regexp.Compile("plan\\.sh|plan\\.ps1")
			}

			if (info.IsDir() == false && r.MatchString(path) == true) {
				// remove test planfiles
				// exclude linux2 planfile if target is linux
				if (target == "linux" && strings.Contains(path, "kernel2") == false) {
					var relativePath, _ = filepath.Rel(dirpath, path)
					files = append(files, relativePath)
				} else if (target == "windows" || target == "all") {
					var relativePath, _ = filepath.Rel(dirpath, path)
					files = append(files, relativePath)
				}
			}
			return nil
		})

	return files, err
}

func getPackageData(list []string, dirpath string) {
	var filename string = "list_of_package.json"

	type Package struct {
		Planfile string `json:"planfile"`
		Origin string `json:"pkg_origin"`
		Name string `json:"pkg_name"`
		Version string `json:"pkg_version"`
		Source string `json:"pkg_source"`
	}

	var PackageList []Package

	// name of parameter to read from planfile
	//var param = [4]string{"pkg_origin", "pkg_name", "pkg_version", "pkg_source"}

	// read planfile and fetch plan meta data
	for _, planfile := range list {
		var cfg, err = ini.LoadSources(ini.LoadOptions{
			SkipUnrecognizableLines: true,
			}, dirpath + "/" + planfile)

		if (err != nil) {
			log.Printf("ERR fail to load planfile [%s], err[%s] \n", planfile, err)
		}

		var item Package

		// Classic read of values, default section can be represented as empty string
		if(strings.Contains(planfile, "plan.ps1") == true) {
			// windows planfile
			item = Package{Origin: cfg.Section("").Key("$pkg_origin").String(),
				Name: cfg.Section("").Key("$pkg_name").String(),
				Version: cfg.Section("").Key("$pkg_version").String(),
				Source: cfg.Section("").Key("$pkg_source").String()}
		} else {
			// linux planfile
			item = Package{Origin: cfg.Section("").Key("pkg_origin").String(),
				Name: cfg.Section("").Key("pkg_name").String(),
				Version: cfg.Section("").Key("pkg_version").String(),
				Source: cfg.Section("").Key("pkg_source").String()}
		}

		// update planfile name
		item.Planfile = planfile

		// add to list
		PackageList = append(PackageList, item)
	}

	// convert list of JSON
	jsonString, err := json.Marshal(PackageList)
	if(err != nil) {
		log.Printf("ERR failed to encode json; [%s]", err)
		return
	}

	// delete content of file
	err = os.Remove(filename)
	if(err != nil) {
		log.Printf("ERR failed to delete content of [%s]; [%s]", filename, err)
		return
	}

	// write to file
	err = ioutil.WriteFile(filename, jsonString, 0644)
	if(err != nil) {
		log.Printf("ERR failed to write content of [%s]; [%s]", filename, err)
		return
	}

	log.Printf("INFO created list of package; file[%s]", filename)
}

func getConf(packagelist, versionlist string) {
	var filename string = "list_of_version_source.json"

	type VersionSource struct {
		Planfile string `json:"planfile"`
		Origin string `json:"pkg_origin"`
		Name string `json:"pkg_name"`
		Version string `json:"pkg_version"`
		Source string `json:"pkg_source"`
		Home string `json:"home"`
		URL string `json:"url"`
	}

	var VersionSourceList []VersionSource

	// read packagelist
	// read versionlist

	// sort versionlist json object


	// convert list of JSON
	jsonString, err := json.Marshal(VersionSourceList)
	if(err != nil) {
		log.Printf("ERR failed to encode json versionsourcelist; [%s]", err)
		return
	}

	// delete content of file
	err = os.Remove("./"+filename)
	if(err != nil) {
		log.Printf("ERR failed to delete content of [%s]; [%s]", filename, err)
		return
	}

	// write to file
	err = ioutil.WriteFile(filename, jsonString, 0644)
	if(err != nil) {
		log.Printf("ERR failed to write content of [%s]; [%s]", filename, err)
		return
	}

	log.Printf("INFO created list of version source; file[%s]", filename)
}
