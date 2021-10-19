package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strings"
	"time"
)

func marshal(w http.ResponseWriter, resp interface{}) {
	b, err := json.Marshal(resp)
	if err != nil {
		handleError(w, err)
		return
	}
	_, err = fmt.Fprint(w, string(b))
	if err != nil {
		handleError(w, err)
		return
	}
}

func root(w http.ResponseWriter, _ *http.Request) {
	marshal(w, map[string]string{
		"hello": "world",
	})
}

func env(w http.ResponseWriter, _ *http.Request) {
	vars := map[string]string{}
	for _, e := range os.Environ() {
		pair := strings.SplitN(e, "=", 2)
		vars[pair[0]] = pair[1]
	}
	marshal(w, vars)
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "9876"
	}

	http.HandleFunc("/", logMiddleware(root))
	http.HandleFunc("/env", logMiddleware(env))
	log("listening on %s", port)
	_ = http.ListenAndServe("0.0.0.0:" + port, nil)
}


func handleError(w http.ResponseWriter, err error) {
	log("ERROR: %s", err.Error())
	http.Error(w, http.StatusText(500), 500)
}

type statusRecorder struct {
	http.ResponseWriter
	status int
}

func (rec *statusRecorder) WriteHeader(code int) {
	rec.status = code
	rec.ResponseWriter.WriteHeader(code)
}

func logMiddleware(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		t1 := time.Now()
		rec := statusRecorder{w, 200}
		next(&rec, r)
		t2 := time.Now()
		log("[%d] %s - %s %s", rec.status, t2.Sub(t1), r.Method, r.URL.RequestURI())
	}
}

func log(msg string, args ...interface{}) {
	fmt.Printf("%s - %s\n", time.Now().Format(time.RFC3339Nano), fmt.Sprintf(msg, args...))
}
