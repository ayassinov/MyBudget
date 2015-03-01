
-- +goose Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE IF NOT EXISTS mb_category
(
  id          SERIAL PRIMARY KEY          NOT NULL,
  code        VARCHAR(5)                  NOT NULL,
  parentid    BIGINT                      NULL,
  name        VARCHAR(150)                NOT NULL,
  description VARCHAR(255),
  createdat   TIMESTAMP WITHOUT TIME ZONE NOT NULL  DEFAULT now(),
  updatedat   TIMESTAMP WITHOUT TIME ZONE NOT NULL  DEFAULT now()
);

ALTER TABLE IF EXISTS mb_category ADD CONSTRAINT FK_CATEGORY_PARENT_ID FOREIGN KEY (parentid) REFERENCES mb_category (id);

ALTER TABLE IF EXISTS mb_category ADD CONSTRAINT IDX_CATEGORY_NAME UNIQUE (name);
ALTER TABLE IF EXISTS mb_category ADD CONSTRAINT IDX_CATEGORY_CODE UNIQUE (code);


INSERT INTO mb_category (code, parentid, name, description)
VALUES ('EVDEX', NULL, 'Everyday Expenses', 'Parent category for everyday expenses');

INSERT INTO mb_category (parentid, code, name, description)
    VALUES ((SELECT id FROM mb_category where code = 'EVDEX'), 'GRORY', 'Groceries', 'Groceries budget'),
    ((SELECT id FROM mb_category where code = 'EVDEX'), 'HGOOD', 'Households Goods', 'Households Goods budget'),
    ((SELECT id FROM mb_category where code = 'EVDEX'), 'FUEL', 'Fuel', 'Fuel budget'),
    ((SELECT id FROM mb_category where code = 'EVDEX'), 'RESTS', 'Restaurants', 'Restaurants budget'),
    ((SELECT id FROM mb_category where code = 'EVDEX'), 'SPMNY', 'Spending Money', 'Spending Money budget');
 

INSERT INTO mb_category (code, parentid, name, description)
VALUES ('MTHBL', NULL, 'Monthly Bills', 'Parent category for Monthly Bills');

INSERT INTO mb_category (parentid, code, name, description)
    VALUES ((SELECT id FROM mb_category where code = 'EVDEX'), 'RENT', 'Rent/Mortgage', 'Rent/Mortgage budget'),
    ((SELECT id FROM mb_category where code = 'MTHBL'), 'WATER', 'Water', 'Water budget'),
    ((SELECT id FROM mb_category where code = 'MTHBL'), 'NATGS', 'Natural Gas', 'Natural Gas budget'),
    ((SELECT id FROM mb_category where code = 'MTHBL'), 'PHONE', 'Phone', 'Phone budget'),
    ((SELECT id FROM mb_category where code = 'MTHBL'), 'INET', 'Internet', 'Internet budget');

-- +goose Down
-- SQL section 'Down' is executed when this migration is rolled back

DROP TABLE mb_category CASCADE;