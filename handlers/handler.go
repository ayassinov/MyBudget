package handlers

import (
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
	"github.com/parisianninjas/mybudget/datastore"
	"github.com/parisianninjas/mybudget/routes"
)

var categoryStore = &datastore.CategoryStoreImpl{}

//HandleAPI define handlers for api
func HandleAPI() *mux.Router {
	m := routes.API()
	m.Get(routes.GetCategory).Handler(handler(handleGetCategory))
	m.Get(routes.ListCategories).Handler(handler(handleListCategory))
	m.Get(routes.CreateCategory).Handler(handler(handleCreateCategory))
	return m
}

type handler func(http.ResponseWriter, *http.Request) error

func (h handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	err := h(w, r)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(w, "error: %s", err)
		log.Println(err)
	}
}

func handleGetCategory(w http.ResponseWriter, r *http.Request) error {
	id, err := strconv.Atoi(mux.Vars(r)["ID"])
	if err != nil {
		return err
	}

	c, err := categoryStore.Get(id)

	if err != nil {
		return err
	}

	return writeJSON(w, c)
}

func handleListCategory(w http.ResponseWriter, r *http.Request) error {
	page, err := strconv.Atoi(r.URL.Query().Get("page"))
	if err != nil {
		page = 0
	}
	count, err := strconv.Atoi(r.URL.Query().Get("count"))
	if err != nil {
		count = 10
	}
	categories, err := categoryStore.List(page, count)

	if err != nil {
		return err
	}

	return writeJSON(w, categories)
}

func handleCreateCategory(w http.ResponseWriter, r *http.Request) error {
	c := &datastore.Category{Name: "Hello", Description: "Yo"}
	err := categoryStore.Create(c)
	if err != nil {
		return err
	}
	return writeJSON(w, c)
}
