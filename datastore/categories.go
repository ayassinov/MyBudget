package datastore

import "gopkg.in/gorp.v1"

//Category of the budget
type Category struct {
	ID            int64      `json:"id" db:"id"`
	ParentID      *int64     `json:"-" db:"parent_id"`
	UserID        *int64     `json:"-" db:"user_id"`
	Parent        *Category  `json:"parent_category"`
	SubCategories Categories `json:"sub_categories"`
	Name          string     `json:"name"`
	Description   *string    `json:"description"`
	Default       bool       `json:"default" db:"isdefault"`
	//CreatedAt     time.Time  `json:"-" db:"cat_createdat"`
	//UpdatedAt     time.Time  `json:"-" db:"cat_updatedat"`
}

//Categories is a list of category type
type Categories []Category

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
func (c CategoryStoreImpl) Get(id int) (Category, error) {

	var cat = Category{}
	err := DB.SelectOne(&cat, "select * from bdg_category where id =$1", id)

	if err == nil && cat.ParentID != nil {
		err = DB.SelectOne(&cat.Parent, "select * from bdg_category where id=$1", cat.ParentID)
	}

	if err == nil {
		var categories Categories
		_, err = DB.Select(&categories, "select * from bdg_category where parent_id = :Key", map[string]interface{}{
			"Key": id,
		})

		cat.SubCategories = categories
	}

	return cat, err
}

//List ...
func (c CategoryStoreImpl) List(page int, count int) ([]*Category, error) {
	page = page - 1 //postgres offset start from 0
	if page < 0 {
		page = 0
	}

	query := "select * from bdg_category order by id offset $1 limit $2"

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
	//i.CreatedAt = time.Now()
	//i.UpdatedAt = i.CreatedAt
	return nil
}

//PreUpdate update the update date when updating a category
func (i *Category) PreUpdate(s gorp.SqlExecutor) error {
	//i.UpdatedAt = time.Now()
	return nil
}
