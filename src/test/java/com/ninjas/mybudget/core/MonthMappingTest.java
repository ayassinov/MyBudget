package com.ninjas.mybudget.core;

import com.ninjas.mybudget.MyBudgetApplication;
import com.ninjas.mybudget.conf.PersistenceConfig;
import com.ninjas.mybudget.core.domain.Month;
import com.ninjas.mybudget.repository.MonthRepository;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;

import javax.transaction.Transactional;
import java.util.List;


/**
 * @author ayassinov on 23/09/14.
 */
@Transactional
@ActiveProfiles("test")
@RunWith(SpringJUnit4ClassRunner.class)
@TransactionConfiguration(defaultRollback = true)
@ContextConfiguration(classes = {PersistenceConfig.class})
@SpringApplicationConfiguration(classes = MyBudgetApplication.class)
public class MonthMappingTest {

    @Autowired
    MonthRepository manager;

    @Test
    public void thatItemCustomMappingWorks() throws Exception {
        Month month = new Month();
        month.setMonthOfYear("1");
        month.setName("JANVIER");
        month.setYear(2014);

        manager.save(month);

        final List<Month> byYear = manager.findByYear(2014);
        Assert.assertThat(byYear.size(), Matchers.is(1));

        // assertTableExists(manager, "bdg_month");

        //assertTableHasColumn(manager, "bdg_month", "id");
        //assertTableHasColumn(manager, "bdg_month", "month_of_year");
        //assertTableHasColumn(manager, "bdg_month", "name");
        //assertTableHasColumn(manager, "bdg_month", "year");
    }

}
