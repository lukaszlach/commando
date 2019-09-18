package main

import(
		"log"
		"net/url"
		"net/http"
		"net/http/httputil"
		"regexp"
		"os/exec"
)

func main() {
		remote, err := url.Parse("http://registry:5000")
		if err != nil {
				panic(err)
		}

		proxy := httputil.NewSingleHostReverseProxy(remote)
		http.HandleFunc("/", handler(proxy))
		err = http.ListenAndServe(":5050", nil)
		if err != nil {
				panic(err)
		}
}

func handler(p *httputil.ReverseProxy) func(http.ResponseWriter, *http.Request) {
		var manifestExpr = regexp.MustCompile(`^/v2/[a-zA-Z0-9._/-]+/manifests/latest$`)
		return func(w http.ResponseWriter, r *http.Request) {
				log.Println(r.URL)
				if r.Method == http.MethodGet && manifestExpr.MatchString(r.URL.String()) {
					log.Println("Executing shell command")
					cmd := exec.Command("bash", "/builder/shell.sh", r.URL.String());
					out, err := cmd.CombinedOutput()
					if err != nil {
						log.Println("Error executing shell command")
						w.WriteHeader(http.StatusBadRequest)
						w.Write(out)
						return
					}
				}
				p.ServeHTTP(w, r)
		}
}