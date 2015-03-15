--list of category used in transaction create/edit screen to define a category to use ?
SELECT
  c.id,
  concat(p.name, ' : ', c.name)
FROM bdg_category c, bdg_category p
WHERE c.parent_id = p.id
      AND c.user_id IS NULL;

-- list des budget
SELECT
  p.name,
  concat(d.month, '/', d.year),
  concat(pc.name, ' : ', c.name),
--b.target,
  bd.budgeded,
  coalesce(s.spent, 0)                             AS spended,
  b.balance + (bd.budgeded - coalesce(s.spent, 0)) AS balance
FROM bdg_budget b
  INNER JOIN bdg_plan p ON p.id = b.plan_id
  INNER JOIN bdg_category c ON c.id = b.category_id
  INNER JOIN bdg_category pc ON pc.id = c.parent_id
  INNER JOIN bdg_budget_date bd ON bd.budget_id = b.id
  INNER JOIN bdg_date d ON d.id = bd.date_id
  LEFT JOIN (SELECT
               t.date_id,
               t.budget_id,
               sum(t.amount) AS spent
             FROM bdg_transaction t
             GROUP BY t.date_id, t.budget_id) s ON s.budget_id = b.id AND s.date_id = d.id
WHERE d.month = 3
      AND d.year = 2015
      AND p.id = 1