using StatsPlots # using version 0.14.33
using PlotThemes # using version 3.0.0
using LaTeXStrings # using version 1.3.0

# From repository ldbounds-for-julia provided by Mattias Nordin (2022) 
# available at: https://github.com/mattiasnordin/ldbounds-for-julia
include("generate_bounds.jl") 

### n-list function. for computing number of observations observed from each treatment at each wave of testing
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
# for equal increments in statistical information denoted by _e
I_e = [0.1:0.1:1;]
# for unequal increments in statistical information denoted by _u
I_u = [0.1, 0.15, 0.21, 0.28, 0.3, 0.7, 0.71, 0.87, 0.95, 1]

N = 10000 # maximum number of observations from each treatment, does not matter for apparence of the plot but need to be specified
K = 10 # maximum number of interim analyses 

# computing number of observations observed from each treatment at each wave of testing
N_LIST_e = mynlist(K, N, I_e)
N_LIST_u = mynlist(K, N, I_u)

## create critical values using generate_bounds.jl provided by Mattias Nordin
# equal increments 
AL_LIST_e = gen_alpha_list(alpha, N_LIST_e, "O'Brien-Fleming")
Z_LIST_e = get_bounds(I_e, AL_LIST_e)
crit_pval_e = ones(K) - cdf(Normal(0,1), Z_LIST_e)
# unequal increments
AL_LIST_u = gen_alpha_list(alpha, N_LIST_u, "O'Brien-Fleming")
Z_LIST_u = get_bounds(I_u, AL_LIST_u)
crit_pval_u = ones(K) - cdf(Normal(0,1), Z_LIST_u)

## function to get the cumulative values of the spending function
function avalsen(A_LIST)
    nlist = zeros(K)
    for k in 1:K
        nlist[k] = sum(A_LIST[1:k])
    end   
    return nlist
end

## the cumulative values of the spending function
# equal increments
a_e = avalsen(AL_LIST_e)
# unequal increments
a_u = avalsen(AL_LIST_u)

### make plot ###

my_plot = plot(size=(600,600))

xaxis!(my_plot, (-0.05, 1.05), latexstring("\\textit{Information\\; time,\\;}\\tau"))
yaxis!(my_plot, (-0.002, 0.0505), latexstring("\\textit{Significance\\; level,\\;}\\alpha"))

plot!(my_plot, I_e, a_e, lab=latexstring("\\alpha_{OBF}^{*}(\\tau_{Equal})"), m=:square, ls=:dot)
plot!(my_plot, I_u, a_u, lab=latexstring("\\alpha_{OBF}^{*}(\\tau_{Unequal})"), m=:circle, ls=:dot,legend=:topleft, theme(:mute))

savefig(my_plot, "obfplot.pdf")