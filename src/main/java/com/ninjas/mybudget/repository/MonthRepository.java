package com.ninjas.mybudget.repository;

import com.ninjas.mybudget.core.domain.Month;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author ayassinov on 22/09/14.
 */
@Repository
public interface MonthRepository extends CrudRepository<Month, Long> {

    List<Month> findByYear(int year);
}
