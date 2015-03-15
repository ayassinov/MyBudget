-- +goose Up
-- SQL in section 'Up' is executed when this migration is applied

--adding users
INSERT INTO bdg_user (id, uuid, firstname, lastname, urlimage, email, password)
VALUES (0, '00001', 'DEFAULT_USER', '', NULL, 'FAKEEMAIL@ANYDOMAIN.COM', 'COMPLEX_PASSWORD');

INSERT INTO bdg_user (uuid, firstname, lastname, urlimage, email, password)
VALUES ('AA0001', 'John', 'Malkovich', 'me.jpg', 'jmlk@gmail.com', 'my_very_secret_password');

INSERT INTO bdg_user (uuid, firstname, lastname, urlimage, email, password)
VALUES ('BB00001', 'Milla', 'Yougovich', 'me.jpg', 'milla@gmail.com', 'guess_what?_its_a_clear_password_:)');


--
INSERT INTO bdg_plan (name, description)
VALUES ('Family Budget', 'Our family Budget');

INSERT INTO bdg_plan (name, description)
VALUES ('Business Budget', 'Our family Business Budget');

INSERT INTO bdg_user_plan (plan_id, user_id)
  SELECT
    u.id,
    p.id
  FROM bdg_user u, bdg_budget p
  WHERE u.id IN (1, 2)
        AND p.id = 1;

INSERT INTO bdg_user_plan (plan_id, user_id)
  SELECT
    u.id,
    p.id
  FROM bdg_user u, bdg_plan p
  WHERE u.id = 1
        AND p.id = 2;

--account type
INSERT INTO bdg_account_type (name, code) VALUES ('Checking', 'CHEKING');
INSERT INTO bdg_account_type (name, code) VALUES ('Savings', 'SAVINGS');
INSERT INTO bdg_account_type (name, code) VALUES ('Credit Cards', 'CREDITCARD');
INSERT INTO bdg_account_type (name, code) VALUES ('Cash', 'CASH');
INSERT INTO bdg_account_type (name, code) VALUES ('Paypal', 'PAYPAL');
INSERT INTO bdg_account_type (name, code) VALUES ('BitCoin', 'BITCOIN');
INSERT INTO bdg_account_type (name, code) VALUES ('Investment Accounts', 'INVEST');
INSERT INTO bdg_account_type (name, code) VALUES ('Mortgage', 'MORTAGE');
INSERT INTO bdg_account_type (name, code) VALUES ('Other Assets', 'OTHASSETS');
INSERT INTO bdg_account_type (name, code) VALUES ('Other Liabilities', 'OTHLIAB');


--account
INSERT INTO bdg_account (plan_id, type_id, name, description)
VALUES (1, 1, 'Ingdirect', 'Our ingdirect Checking account');

INSERT INTO bdg_account (plan_id, type_id, name, description)
VALUES (1, 2, 'Livret A SG', 'Livret A saving account');

INSERT INTO bdg_account (plan_id, type_id, name, description)
VALUES (1, 7, 'Compte PEA Boursourama', 'Stock investement account');

INSERT INTO bdg_account (plan_id, type_id, name, description)
VALUES (2, 1, 'Ingdirect myBudget', 'My business account for mybudet application');

INSERT INTO bdg_account (plan_id, type_id, name, description)
VALUES (2, 5, 'Paypal myBudget', 'My Paypal account for mybudget application');


--payee
INSERT INTO bdg_payee (plan_id, name) VALUES (1, 'Pizzaria Venezia');
INSERT INTO bdg_payee (plan_id, name) VALUES (1, 'Monoprix');
INSERT INTO bdg_payee (plan_id, name) VALUES (1, 'La poste');


INSERT INTO bdg_category (parent_id, user_id, name) VALUES (NULL, NULL, 'Monthly Bills');
INSERT INTO bdg_category (parent_id, user_id, name) VALUES (NULL, NULL, 'Everyday Expenses');
INSERT INTO bdg_category (parent_id, user_id, name) VALUES (NULL, NULL, 'Rainy day funds');

INSERT INTO bdg_category (parent_id, user_id, name) VALUES (1, NULL, 'Rent');
INSERT INTO bdg_category (parent_id, user_id, name) VALUES (1, NULL, 'Phone');
INSERT INTO bdg_category (parent_id, user_id, name) VALUES (1, NULL, 'Internet');
INSERT INTO bdg_category (parent_id, user_id, name) VALUES (1, NULL, 'Electricity');
INSERT INTO bdg_category (parent_id, user_id, name) VALUES (1, NULL, 'Natural Gas');
--
INSERT INTO bdg_category (parent_id, user_id, name) VALUES (2, NULL, 'Groceries');
INSERT INTO bdg_category (parent_id, user_id, name) VALUES (2, NULL, 'Restaurants');
INSERT INTO bdg_category (parent_id, user_id, name) VALUES (2, NULL, 'Medical');
INSERT INTO bdg_category (parent_id, user_id, name) VALUES (2, NULL, 'Clothes');
--
INSERT INTO bdg_category (parent_id, user_id, name) VALUES (3, NULL, 'Emergency fund');
INSERT INTO bdg_category (parent_id, user_id, name) VALUES (3, NULL, 'Birthdays');


INSERT INTO bdg_budget (plan_id, category_id) VALUES (1, 4);
INSERT INTO bdg_budget (plan_id, category_id) VALUES (1, 5);
INSERT INTO bdg_budget (plan_id, category_id) VALUES (1, 6);
INSERT INTO bdg_budget (plan_id, category_id) VALUES (1, 7);
INSERT INTO bdg_budget (plan_id, category_id) VALUES (1, 8);
INSERT INTO bdg_budget (plan_id, category_id) VALUES (1, 9);
INSERT INTO bdg_budget (plan_id, category_id) VALUES (1, 10);
INSERT INTO bdg_budget (plan_id, category_id) VALUES (1, 11);
INSERT INTO bdg_budget (plan_id, category_id) VALUES (1, 12);
INSERT INTO bdg_budget (plan_id, category_id) VALUES (1, 13);
INSERT INTO bdg_budget (plan_id, category_id) VALUES (1, 14);

INSERT INTO bdg_date (year, month) VALUES (2015, 3);


INSERT INTO bdg_budget_date (budget_id, date_id, budgeded) VALUES (1, 1, 1200);
INSERT INTO bdg_budget_date (budget_id, date_id, budgeded) VALUES (2, 1, 70);
INSERT INTO bdg_budget_date (budget_id, date_id, budgeded) VALUES (3, 1, 35);
INSERT INTO bdg_budget_date (budget_id, date_id, budgeded) VALUES (4, 1, 31);
INSERT INTO bdg_budget_date (budget_id, date_id, budgeded) VALUES (5, 1, 40);
INSERT INTO bdg_budget_date (budget_id, date_id, budgeded) VALUES (6, 1, 200);
INSERT INTO bdg_budget_date (budget_id, date_id, budgeded) VALUES (7, 1, 250);
INSERT INTO bdg_budget_date (budget_id, date_id, budgeded) VALUES (8, 1, 90);
INSERT INTO bdg_budget_date (budget_id, date_id, budgeded) VALUES (9, 1, 50);
INSERT INTO bdg_budget_date (budget_id, date_id, budgeded) VALUES (10, 1, 250);
INSERT INTO bdg_budget_date (budget_id, date_id, budgeded) VALUES (11, 1, 20);


INSERT INTO bdg_transaction (date_id, budget_id, account_id, amount, valuedate) VALUES (1, 1, 1, -1200, now());


-- +goose Down
-- SQL section 'Down' is executed when this migration is rolled back

TRUNCATE TABLE bdg_transaction;
TRUNCATE TABLE bdg_budget_date;
TRUNCATE TABLE bdg_date;
TRUNCATE TABLE bdg_budget;
TRUNCATE TABLE bdg_category;
TRUNCATE TABLE bdg_payee;
TRUNCATE TABLE bdg_account;
TRUNCATE TABLE bdg_account_type;
TRUNCATE TABLE bdg_user_plan;
TRUNCATE TABLE bdg_plan;
TRUNCATE TABLE bdg_user;
