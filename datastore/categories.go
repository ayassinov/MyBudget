package datastore

import (
	"time"

	"gopkg.in/gorp.v1"
)

//Category of the budget
type Category struct {
	ID          int64     `json:"id,omitempty"`
	ParentID    int64     `json:"-"`
	Parent      *Category `db:"-"` //TODO(yab) how to manage a recursive Category ?
	Name        string
	Description string
	CreatedAt   int64 `json:"-"`
	UpdatedAt   int64 `json:"-"`
}

//CategoryStore interface to implement for the
type CategoryStore interface {

	// Get a category by id.
	Get(id int) (*Category, error)

	// List posts using the page number and the count of elements to fech
	List(page int, count int) ([]*Category, error)

	// Create a category
	Create(category *Category) error

	// Update a category
	Update(category *Category) error
}

//CategoryStoreImpl implementation of the category store interface
type CategoryStoreImpl struct { /* TODO(yab) add db *gorp.DbMap ?*/
}

//Get ...
func (c CategoryStoreImpl) Get(id int) (*Category, error) {
	obj, err := DB.Get(Category{}, id)
	res := obj.(*Category)
	return res, err
}

//List ...
func (c CategoryStoreImpl) List(page int, count int) ([]*Category, error) {
	page = page - 1 //postgres offset start from 0
	if page < 0 {
		page = 0
	}

	query := "select * from mb_category order by id offset $1 limit $2"

	var list []*Category
	_, err := DB.Select(&list, query, page, count)
	return list, err
}

//Create ...
func (c CategoryStoreImpl) Create(category *Category) error {
	err := DB.Insert(category)
	return err
}

//Update ...
func (c CategoryStoreImpl) Update(category *Category) error {
	_, err := DB.Update(category)
	return err
}

//PreInsert update the creation and update date when saving a category
func (i *Category) PreInsert(s gorp.SqlExecutor) error {
	i.CreatedAt = time.Now().UnixNano()
	i.UpdatedAt = i.CreatedAt
	return nil
}

//PreUpdate update the update date when updating a category
func (i *Category) PreUpdate(s gorp.SqlExecutor) error {
	i.UpdatedAt = time.Now().UnixNano()
	return nil
}
