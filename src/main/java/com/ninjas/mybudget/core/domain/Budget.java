package com.ninjas.mybudget.core.domain;

import java.util.ArrayList;
import java.util.List;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * @author ayassinov on 21/09/14.
 */
@Getter
@Setter
@NoArgsConstructor
@EqualsAndHashCode(of = {"category","order","realBalance"})
@ToString
public class Budget {
	
    private Category category;

    private int order;

    private double estimatedBalance;

    private double realBalance;

    private double gap;

    @JsonIgnore
    private List<Transaction> transactions = new ArrayList<>();
    
    public Budget(int order, double estimatedBalance, double realBalance, double gap, Category category){
    	this.order = order;
    	this.estimatedBalance = estimatedBalance;
    	this.realBalance = realBalance;
    	this.gap = gap;
    	this.category = category;
    }
    
    public Budget(int order, double estimatedBalance, double realBalance, double gap, Category category, List<Transaction> transactions){
    	this.order = order;
    	this.estimatedBalance = estimatedBalance;
    	this.realBalance = realBalance;
    	this.gap = gap;
    	this.category = category;
    	this.transactions = new ArrayList<Transaction>(transactions);
    }
    
}
