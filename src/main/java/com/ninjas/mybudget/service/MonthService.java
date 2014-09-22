package com.ninjas.mybudget.service;

import com.google.common.base.Preconditions;
import com.ninjas.mybudget.core.domain.Month;
import com.ninjas.mybudget.repository.MonthRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;

/**
 * @author ayassinov on 23/09/14.
 */
@Service
public class MonthService {

    private final MonthRepository monthRepository;

    @Autowired
    public MonthService(MonthRepository monthRepository) {
        this.monthRepository = monthRepository;
    }

    @Transactional
    public List<Month> listByYear(int year) {
        Preconditions.checkArgument(year >= 2014 && year < 2100);
        return monthRepository.findByYear(year);
    }
}
