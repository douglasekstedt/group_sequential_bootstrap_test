# Results obtained using Julia version 1.7.2

using Statistics # using version 1.7.0
using Distributions # using version 0.25.58
using Random 

# From repository ldbounds-for-julia provided by Mattias Nordin (2022) 
# available at: https://github.com/mattiasnordin/ldbounds-for-julia
include("generate_bounds.jl") 

### test statistics to be computed

function mean_diff(Y,X) # difference in means
    return (mean(Y)-mean(X))
end

function median_diff(Y,X) # difference in medians
    return (median(Y)-median(X))
end

function quantile_diff(Y,X) # difference in 90th percentiles
    return (quantile(Y, 0.9) - quantile(X, 0.9))
end

function mean_ratio(Y,X) # ratio of means 
    return (mean(Y)/mean(X))
end

function var_diff(Y,X) # ratio of variances 
    return (sum((Y.-mean(Y)).^2)/ (length(Y)-1))-(sum((X.-mean(X)).^2)/ (length(X)-1))
end

function var_ratio(Y,X) # ratio of variances
    return (sum((Y.-mean(Y)).^2)/ (length(Y)-1))/(sum((X.-mean(X)).^2)/ (length(X)-1))
end

### function for confidence interval 

function confidenceinterval(test_statistic, b_res, crit_pval)
    if String(string(test_statistic)) == "var_ratio" || String(string(test_statistic)) == "mean_ratio" 
        ci = quantile(b_res, [crit_pval/2, 1-(crit_pval/2)])
        # ci does not cover 1
        # true = sig, false = non sig
        ci_res = ifelse(ci[1]>1 || ci[2]<1, true, false)
    else 
        ci = quantile(b_res, [crit_pval/2, 1-crit_pval/2])
        # ci does not cover 0
        # true = sig, false = non sig
        ci_res = ifelse(ci[1]>0 || ci[2]<0, true, false)
    end
return ci_res
end

### function for bootstrap 

function boot(Y, X, crit_pval, B, test_statistics)
    B_res = zeros(B, length(test_statistics))
    for b in 1:B
        Y_b = sample(Y, length(Y), replace = true)
        X_b = sample(X, length(X), replace = true)
        for i in 1:length(test_statistics)
            B_res[b,i] = test_statistics[i](Y_b, X_b)
        end
    end
    ci_res = zeros(length(test_statistics))
    for c in 1:length(test_statistics)
        ci_res[c] = confidenceinterval(test_statistics[c], B_res[1:B,c], crit_pval)
    end
    return ci_res
end

### function for group sequnential bootstrap test

function gst(Y, X, crit_pval, I, B, test_statistics)
    sig = zeros(length(test_statistics))
    for i in 1:length(I)
        res = boot(Y[1:convert(Int64, round((length(Y)*I[i]), digits=0))], X[1:convert(Int64, round((length(X)*I[i]), digits=0))], crit_pval[i], B, test_statistics)
        for r in 1:length(res)
            if res[r] == true && sig[r] == 0
                sig[r] = 1
            end
        end
    end
    return sig
end

### main simulation function

function sim_fun(some_seed, I, R, B, N, crit_pval, test_statistics, dgp)
    Random.seed!(some_seed)
    temp = zeros(length(test_statistics))
    Res = zeros(R,length(test_statistics))
    for r in 1:R
        Y = rand(dgp, N)
        X = rand(dgp, N)
        println(r)
        temp = gst(Y, X, crit_pval, I, B, test_statistics)
        for t in 1:length(temp)
            Res[r,t] = temp[t]
        end
    end
    return mean(Res, dims=1) 
end

### n-list function
# for computing number of observations observed from each treatment at each wave of testing

function mynlist(K, N, I)
    nlist = zeros(K)
    for k in 1:K
        if k > 1
            nlist[k] = (N*I[k] - N*I[k-1])
        else
            nlist[k] = N*I[k]
        end
    end   
    return nlist
end

### specification of test  

alpha = 0.05 # intended significance level

## information times 
# for equal increments in statistical information
I = [0.1:0.1:1;] 
# for unequal increments in statistical information
#I = [0.1, 0.15, 0.21, 0.28, 0.3, 0.7, 0.71, 0.87, 0.95, 1]

N = 100 # maximum number of observations from each treatment
R = 10000 # number of replications
B = 10000 # number of bootstrap samples 
K = 10 # maximum number of interim analyses

# create critical values using generate_bounds.jl provided by Mattias Nordin
# From repository ldbounds-for-julia provided by Mattias Nordin (2022) 
# available at: https://github.com/mattiasnordin/ldbounds-for-julia

N_LIST = mynlist(K, N, I)
AL_LIST = gen_alpha_list(alpha, N_LIST, "O'Brien-Fleming")
Z_LIST = get_bounds(I, AL_LIST)

# critical value inverted alphas 
crit_pval = ones(K) - cdf(Normal(0,1), Z_LIST)

# list of statistics of interest considered
my_tests = [mean_diff, median_diff, quantile_diff, mean_ratio, var_diff, var_ratio]

# resulting estimated false positive rate
# remove # below to RUN
#res = sim_fun(1234, I, R, B, N, crit_pval, my_tests, Normal(1,1))
#println(res)