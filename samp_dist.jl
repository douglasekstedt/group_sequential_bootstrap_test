# Results obtained using Julia version 1.7.2

using Statistics # using version 1.7.0
using Distributions # using version 0.25.58
using Random 
using Plots # using version 1.29.0
using StatsBase # using version 0.33.16
using StatsPlots # using version 0.14.33
using LaTeXStrings # using version 1.3.0

include("group_sequential_bootstrap_test.jl") # importing functions to compute test statistics

### function for generating sampling distributions

function gen_samp_dist(some_seed, dgp, R, N, test_statistics)
    Random.seed!(some_seed)
    res = zeros(R, length(test_statistics))
    for r in 1:R
        Y = rand(dgp, N)
        X = rand(dgp, N)
        for i in 1:length(test_statistics)
            res[r,i] = test_statistics[i](Y, X)
        end
    end
    return res
end

# test statistics to be computed
test_stats = [mean_diff, median_diff, quantile_diff, mean_ratio, var_diff, var_ratio]

#### create plots 

plot_font = "Computer Modern" # set font of plot

### create plots of sampling distributions N = 10

samp_dist_N11 = gen_samp_dist(1234, Normal(1,1), 1000000, 10, test_stats) # Normal(1,1)
samp_dist_N01 = gen_samp_dist(1234, Normal(0,1), 1000000, 10, [mean_ratio]) # Normal(0,1)
samp_dist_E1 = gen_samp_dist(1234, Exponential(1), 1000000, 10, test_stats) # Exponential(0,1)

## Normal(1,1)

# difference in means 
my_hist = histogram(size=(600,600))
fit_result1 = fit(Normal, samp_dist_N11[:,1]) # mean_diff
histogram!(my_hist, samp_dist_N11[:,1], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;means}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1)
plot!(my_hist, fit_result1, label=latexstring("\\textit{Normal(0.0,0.20)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_mean_diff10.pdf")

# difference in medians
my_hist = histogram(size=(600,600))
fit_result2 = fit(Normal, samp_dist_N11[:,2]) # median_diff
histogram!(my_hist, samp_dist_N11[:,2], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;medians}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result2, label=latexstring("\\textit{Normal(0.0,0.28)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_median_diff10.pdf")

# difference in 90th percentiles 
my_hist = histogram(size=(600,600))
fit_result3 = fit(Normal, samp_dist_N11[:,3]) # quantile_diff
histogram!(my_hist, samp_dist_N11[:,3], normalize =:pdf, label=latexstring("\\textit{difference\\,in\\,90th\\,percentiles}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result3, label=latexstring("\\textit{Normal(-0.0,0.42)}"), legend=(0.6295, 0.989), linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_90thpercentile_diff10.pdf")

# ratio of means
my_hist = histogram(size=(600,600))
fit_result4 = fit(Normal, samp_dist_N11[:,4]) # mean_ratio
histogram!(my_hist, samp_dist_N11[:,4], normalize =:pdf, label=latexstring("\\textit{ratio\\;of\\;means}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result4, label=latexstring("\\textit{Normal(1.0,3293)}"), legend=:topleft, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_mean_ratio10.pdf")

# difference in variances
my_hist = histogram(size=(600,600))
fit_result5 = fit(Normal, samp_dist_N11[:,5]) # var_diff
histogram!(my_hist, samp_dist_N11[:,5], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;variances}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result5, label=latexstring("\\textit{Normal(-0.0,0.45)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_var_diff10.pdf")

# ratio of variances
my_hist = histogram(size=(600,600))
fit_result6 = fit(Normal, samp_dist_N11[:,6]) # var_ratio
histogram!(my_hist, samp_dist_N11[:,6], normalize =:pdf, label=latexstring("\\textit{ratio\\;of\\;variances}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result6, label=latexstring("\\textit{Normal(1.0,1.16)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_var_ratio10.pdf")

## Normal(0,1)

my_hist = histogram(size=(600,600))
fit_result7 = fit(Normal, samp_dist_N01[:,1]) # mean_ratio
histogram!(my_hist, samp_dist_N11[:,4], normalize =:pdf, label=latexstring("\\textit{ratio\\;of\\;means}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result7, label=latexstring("\\textit{Normal(1.4,2096245.31)}"), legend=:topleft, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, linewidth=1, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N01_mean_ratio10.pdf")

# Exp(1)

# difference in means 
my_hist = histogram(size=(600,600))
fit_result8 = fit(Normal, samp_dist_E1[:,1]) # mean_diff
histogram!(my_hist, samp_dist_E1[:,1],  normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;means}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result8, label=latexstring("\\textit{Normal(-0.0,0.20)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_mean_diff10.pdf")

# difference in medians
my_hist = histogram(size=(600,600))
fit_result9 = fit(Normal, samp_dist_E1[:,2]) # median_diff
histogram!(my_hist, samp_dist_E1[:,2], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;medians}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result9, label=latexstring("\\textit{Normal(-0.0,0.20)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_median_diff10.pdf")

# difference in 90th percentiles 
my_hist = histogram(size=(600,600))
fit_result10 = fit(Normal, samp_dist_E1[:,3]) # quantile_diff
histogram!(my_hist, samp_dist_E1[:,3], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;90th\\;percentiles}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result10, label=latexstring("\\textit{Normal(0.0,1.12)}"), legend=(0.62, 0.985), linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_90thpercentile_diff10.pdf")

# ratio of means
my_hist = histogram(size=(600,600))
fit_result11 = fit(Normal, samp_dist_E1[:,4]) # mean_ratio
histogram!(my_hist, samp_dist_E1[:,4], normalize =:pdf, label=latexstring("\\textit{ratio\\;of\\;means}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result11, label=latexstring("\\textit{Normal(1.0,0.30)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_mean_ratio10.pdf")

# difference in variances
my_hist = histogram(size=(600,600))
fit_result12 = fit(Normal, samp_dist_E1[:,5]) # var_diff
histogram!(my_hist, samp_dist_E1[:,5], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;variances}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result12, label=latexstring("\\textit{Normal(-0.0,1.64)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_var_diff10.pdf")

# ratio of variances
my_hist = histogram(size=(600,600))
fit_result13 = fit(Normal, samp_dist_E1[:,6]) # var_ratio
histogram!(my_hist, samp_dist_E1[:,6], normalize =:pdf, label=latexstring("\\textit{ratio\\;of\\;variances}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result13, label=latexstring("\\textit{Normal(1.0,12.08)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_var_ratio10.pdf")

### create plots of sampling distributions N = 100

samp_dist_N11 = gen_samp_dist(1234, Normal(1,1), 1000000, 100, test_stats) # Normal(1,1)
samp_dist_N01 = gen_samp_dist(1234, Normal(0,1), 1000000, 100, [mean_ratio]) # Normal(0,1)
samp_dist_E1 = gen_samp_dist(1234, Exponential(1), 1000000, 100, test_stats) # Exponential(0,1)

## Normal(1,1)

# difference in means 
my_hist = histogram(size=(600,600))
fit_result1 = fit(Normal, samp_dist_N11[:,1]) # mean_diff
histogram!(my_hist, samp_dist_N11[:,1], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;means}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result1, label=latexstring("\\textit{Normal(0.0, 0.02)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_mean_diff100.pdf")

# difference in medians
my_hist = histogram(size=(600,600))
fit_result2 = fit(Normal, samp_dist_N11[:,2]) # median_diff
histogram!(my_hist, samp_dist_N11[:,2], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;medians}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result2, label=latexstring("\\textit{Normal(0.0, 0.03)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_median_diff100.pdf")

# difference in 90th percentiles 
my_hist = histogram(size=(600,600))
fit_result3 = fit(Normal, samp_dist_N11[:,3]) # quantile_diff
histogram!(my_hist, samp_dist_N11[:,3], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;90th\\;percentiles}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result3, label=latexstring("\\textit{Normal(-0.0, 0.056)}"), legend=(0.62, 0.985), linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_90thpercentile_diff100.pdf")

# ratio of means
my_hist = histogram(size=(600,600))
fit_result4 = fit(Normal, samp_dist_N11[:,4]) # mean_ratio
histogram!(my_hist, samp_dist_N11[:,4], normalize =:pdf, label=latexstring("\\textit{ratio\\;of\\;means}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result4, label=latexstring("\\textit{Normal(1.0, 0.02)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_mean_ratio100.pdf")

# difference in variances
my_hist = histogram(size=(600,600))
fit_result5 = fit(Normal, samp_dist_N11[:,5]) # var_diff
histogram!(my_hist, samp_dist_N11[:,5], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;variances}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result5, label=latexstring("\\textit{Normal(0.0, 0.04)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_var_diff100.pdf")

# ratio of variances
my_hist = histogram(size=(600,600))
fit_result6 = fit(Normal, samp_dist_N11[:,6]) # var_ratio
histogram!(my_hist, samp_dist_N11[:,6], normalize =:pdf, label=latexstring("\\textit{ratio\\;of\\;variances}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result6, label=latexstring("\\textit{Normal(1.0, 0.043)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_var_ratio100.pdf")

## Normal(0,1)

my_hist = histogram(size=(600,600))
fit_result7 = fit(Normal, samp_dist_N01[:,1]) # mean_ratio
histogram!(my_hist, samp_dist_N11[:,4], normalize =:pdf, label=latexstring("\\textit{ratio\\;of\\;means}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result7, label=latexstring("\\textit{Normal(6.1,27900025)}"), legend=:topleft, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, linewidth=1, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N01_mean_ratio100.pdf")

# Exp(1)

# difference in means 
my_hist = histogram(size=(600,600))
fit_result8 = fit(Normal, samp_dist_E1[:,1]) # mean_diff
histogram!(my_hist, samp_dist_E1[:,1],  normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;means}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result8, label=latexstring("\\textit{Normal(-0.0, 0.02)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_mean_diff100.pdf")

# difference in medians
my_hist = histogram(size=(600,600))
fit_result9 = fit(Normal, samp_dist_E1[:,2]) # median_diff
histogram!(my_hist, samp_dist_E1[:,2], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;medians}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result9, label=latexstring("\\textit{Normal(-0.0,0.02)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_median_diff100.pdf")

# difference in 90th percentiles 
my_hist = histogram(size=(600,600))
fit_result10 = fit(Normal, samp_dist_E1[:,3]) # quantile_diff
histogram!(my_hist, samp_dist_E1[:,3], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;90th\\;percentiles}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result10, label=latexstring("\\textit{Normal(0.0, 0.17)}"), legend=(0.615, 0.985), linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_90thpercentile_diff100.pdf")

# ratio of means
my_hist = histogram(size=(600,600))
fit_result11 = fit(Normal, samp_dist_E1[:,4]) # mean_ratio
histogram!(my_hist, samp_dist_E1[:,4], normalize =:pdf, label=latexstring("\\textit{ratio\\;of\\;means}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result11, label=latexstring("\\textit{Normal(1.0, 0.021)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_mean_ratio100.pdf")

# difference in variances
my_hist = histogram(size=(600,600))
fit_result12 = fit(Normal, samp_dist_E1[:,5]) # var_diff
histogram!(my_hist, samp_dist_E1[:,5], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;variances}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result12, label=latexstring("\\textit{Normal(0.0, 0.16)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_var_diff100.pdf")

# ratio of variances
my_hist = histogram(size=(600,600))
fit_result13 = fit(Normal, samp_dist_E1[:,6]) # var_ratio
histogram!(my_hist, samp_dist_E1[:,6], normalize =:pdf, label=latexstring("\\textit{ratio\\;of\\;variances}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result13, label=latexstring("\\textit{Normal(1.1, 0.192)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_var_ratio100.pdf")

### create plots of sampling distributions N = 1000

samp_dist_N11 = gen_samp_dist(1234, Normal(1,1), 1000000, 1000, test_stats) # Normal(1,1)
samp_dist_N01 = gen_samp_dist(1234, Normal(0,1), 1000000, 1000, [mean_ratio]) # Normal(0,1)
samp_dist_E1 = gen_samp_dist(1234, Exponential(1), 1000000, 1000, test_stats) # Exponential(0,1)

## Normal(1,1)

# difference in means 
my_hist = histogram(size=(600,600))
fit_result1 = fit(Normal, samp_dist_N11[:,1]) # mean_diff
histogram!(my_hist, samp_dist_N11[:,1], bins = 1000, normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;means}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result1, label=latexstring("\\textit{Normal(0.0, 0.002)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_mean_diff1000.pdf")

# difference in medians
my_hist = histogram(size=(600,600))
fit_result2 = fit(Normal, samp_dist_N11[:,2]) # median_diff
histogram!(my_hist, samp_dist_N11[:,2], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;medians}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result2, label=latexstring("\\textit{Normal(0.0, 0.003)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_median_diff1000.pdf")

# difference in 90th percentiles 
my_hist = histogram(size=(600,600))
fit_result3 = fit(Normal, samp_dist_N11[:,3]) # quantile_diff
histogram!(my_hist, samp_dist_N11[:,3], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;90th\\;percentiles}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result3, label=latexstring("\\textit{Normal(-0.0, 0.006)}"), legend=(0.62, 0.985), linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_90thpercentile_diff1000.pdf")

# ratio of means
my_hist = histogram(size=(600,600))
fit_result4 = fit(Normal, samp_dist_N11[:,4]) # mean_ratio
histogram!(my_hist, samp_dist_N11[:,4], normalize =:pdf, label=latexstring("\\textit{ratio\\;of\\;means}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result4, label=latexstring("\\textit{Normal(1.001, 0.002)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_mean_ratio1000.pdf")

# difference in variances
my_hist = histogram(size=(600,600))
fit_result5 = fit(Normal, samp_dist_N11[:,5]) # var_diff
histogram!(my_hist, samp_dist_N11[:,5], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;variances}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result5, label=latexstring("\\textit{Normal(-0.0, 0.004)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_var_diff1000.pdf")

# ratio of variances
my_hist = histogram(size=(600,600))
fit_result6 = fit(Normal, samp_dist_N11[:,6]) # var_ratio
histogram!(my_hist, samp_dist_N11[:,6], normalize =:pdf, label=latexstring("\\textit{ratio\\;of\\;variances}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result6, label=latexstring("\\textit{Normal(1.0, 0.004)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N11_var_ratio1000.pdf")

## Normal(0,1)

my_hist = histogram(size=(600,600))
fit_result7 = fit(Normal, samp_dist_N01[:,1]) # mean_ratio
histogram!(my_hist, samp_dist_N11[:,4], normalize =:pdf, label=latexstring("\\textit{ratio\\;of\\;means}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result7, label=latexstring("\\textit{Normal(1.14, 390909)}"), legend=:topleft, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_N01_mean_ratio1000.pdf")

# Exp(1)

# difference in means 
my_hist = histogram(size=(600,600))
fit_result8 = fit(Normal, samp_dist_E1[:,1]) # mean_diff
histogram!(my_hist, samp_dist_E1[:,1],  normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;means}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result8, label=latexstring("\\textit{Normal(-0.0, 0.002)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_mean_diff1000.pdf")

# difference in medians
my_hist = histogram(size=(600,600))
fit_result9 = fit(Normal, samp_dist_E1[:,2]) # median_diff
histogram!(my_hist, samp_dist_E1[:,2], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;medians}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result9, label=latexstring("\\textit{Normal(-0.0,0.002)}"), legend=:topleft, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_median_diff1000.pdf")

# difference in 90th percentiles 
my_hist = histogram(size=(600,600))
fit_result10 = fit(Normal, samp_dist_E1[:,3]) # quantile_diff
histogram!(my_hist, samp_dist_E1[:,3], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;90th\\;percentiles}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result10, label=latexstring("\\textit{Normal(0.0, 0.018)}"), legend=(0.63, 0.985), linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_90thpercentile_diff1000.pdf")

# ratio of means
my_hist = histogram(size=(600,600))
fit_result11 = fit(Normal, samp_dist_E1[:,4]) # mean_ratio
histogram!(my_hist, samp_dist_E1[:,4], normalize =:pdf, label=latexstring("\\textit{ratio\\;of\\;means}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result11, label=latexstring("\\textit{Normal(1.0, 0.002)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_mean_ratio1000.pdf")

# difference in variances
my_hist = histogram(size=(600,600))
fit_result12 = fit(Normal, samp_dist_E1[:,5]) # var_diff
histogram!(my_hist, samp_dist_E1[:,5], normalize =:pdf, label=latexstring("\\textit{difference\\;in\\;variances}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result12, label=latexstring("\\textit{Normal(-0.0, 0.016)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_var_diff1000.pdf")

# ratio of variances
my_hist = histogram(size=(600,600))
fit_result13 = fit(Normal, samp_dist_E1[:,6]) # var_ratio
histogram!(my_hist, samp_dist_E1[:,6], normalize =:true, label=latexstring("\\textit{ratio\\;of\\;variances}"), 
fontfamily=plot_font, markerstrokecolor=:auto, c=1, lc=1, binsize=1)
plot!(my_hist, fit_result13, label=latexstring("\\textit{Normal(1.008, 0.016)}"), legend=:topright, linewidth=3)
yaxis!(my_hist, latexstring("\\textit{Probability\\;density\\;function}"), fontfamily=plot_font)
default(fontfamily=plot_font, framestyle=:box, grid=false, border=:nothing, legendfontsize=10)
savefig(my_hist, "samp_dist_E1_var_ratio1000.pdf")