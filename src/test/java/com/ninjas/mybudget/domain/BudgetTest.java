/**
 * 
 */
package com.ninjas.mybudget.domain;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.not;
import static org.springframework.test.util.MatcherAssertionErrors.assertThat;

import org.junit.Ignore;
import org.junit.Test;

import com.ninjas.mybudget.core.domain.Budget;
import com.ninjas.mybudget.core.domain.Category;

/**
 * @author mmc
 *
 */
public class BudgetTest {

	@Test
	@Ignore
    public void testEquals() {
        final Budget budgetA = new Budget(1,2,2,2, new Category((long)1, "food", null, ""));
        final Budget budgetB = new Budget(1,2,2,2, new Category((long)1, "UGC", null, ""));
        final Budget budgetC = new Budget(3,2,2,2, new Category((long)1, "food", null, ""));
        
        assertThat(budgetA, not(equalTo(budgetB)));
        assertThat(budgetA, equalTo(budgetC));
    }
	
}
