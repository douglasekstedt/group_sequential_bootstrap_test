# Results obtained using Julia version 1.7.2

using StatsPlots # using version 0.14.33
using PlotThemes # using version 3.0.0
using LaTeXStrings # using version 1.3.0

### get data ###

# maximum number of observations from each treatment considered in the simulations
N = ["100", "500", "1000", "5000", "10000"] 

## Results from the simulations performed with equal increments in statistical information

# Treatment responses generated from the normal distribution
# dgp = data generating process 
# dgp, statistic, results for N = ["100", "500", "1000", "5000", "10000"] 
N11_mean_diff_e = [0.0649, 0.0565, 0.053, 0.0588, 0.0535] # difference in means
N11_median_diff_e = [0.0377, 0.0432, 0.0484, 0.051, 0.0488] # difference in medians   
N11_quantile_diff_e = [0.0386, 0.0409, 0.0453, 0.0454, 0.0493] # difference in 90th percentiles   
N11_mean_ratio_e = [0.0634, 0.0565, 0.0531, 0.0588, 0.0535] # ratio of means 
N01_mean_ratio_e = [0.0181, 0.0155, 0.0155, 0.0164, 0.0156] # ratio of means    
N11_var_diff_e = [0.0683, 0.0546, 0.0598, 0.0521, 0.0511]  # ratio of variances   
N11_var_ratio_e = [0.0683, 0.0546, 0.0598, 0.0521, 0.0511] # ratio of variances

# Treatment responses generated from the exponetial distribution

E1_mean_diff_e = [0.0654, 0.0545, 0.0535, 0.0559, 0.0522]     
E1_median_diff_e = [0.0372, 0.0425, 0.0457, 0.0561, 0.0501]    
E1_quantile_diff_e = [0.0389, 0.0423, 0.0448, 0.0506, 0.0503]    
E1_mean_ratio_e = [0.0654, 0.0545, 0.0535, 0.0559, 0.0522] 
E1_var_diff_e = [0.0911, 0.0689, 0.0632, 0.0578, 0.0543]    
E1_var_ratio_e = [0.0911, 0.0689, 0.0632, 0.0578, 0.0543]

### make plots ###

plot_font = "Computer Modern"

default(fontfamily=plot_font, linewidth=1, framestyle=:box, label=nothing, grid=true, border=:nothing)
my_plot_Normal_equal = plot(size=(800,800))
xaxis!(my_plot_Normal_equal, (0, 5),  latexstring("N"))
yaxis!(my_plot_Normal_equal, (0.00, 0.10), latexstring("\\textit{Estimated\\; false\\; positive \\; rate}"))
plot!(my_plot_Normal_equal, N, N11_mean_diff_e, lab=latexstring("N(1,1)\\; \\textit{difference\\;in\\;means}"), m=:square, ls=:dot)
plot!(my_plot_Normal_equal, N, N11_median_diff_e, lab=latexstring("N(1,1)\\; \\textit{difference\\;in\\;medians}"), m=:circle, ls=:dot)
plot!(my_plot_Normal_equal, N, N11_quantile_diff_e, lab=latexstring("N(1,1)\\; \\textit{difference\\;in\\;90th\\;percentiles}"), m=:circle, ls=:dot)
plot!(my_plot_Normal_equal, N, N11_mean_ratio_e, lab=latexstring("N(1,1)\\; \\textit{ratio\\;of\\;means}"), m=:square, ls=:dot)
plot!(my_plot_Normal_equal, N, N11_var_diff_e, lab=latexstring("N(1,1)\\; \\textit{difference\\;in\\;variances}"), m=:square, ls=:dot)
plot!(my_plot_Normal_equal, N, N11_var_ratio_e, lab=latexstring("N(1,1)\\; \\textit{ratio\\;of\\;variances}"), m=:circle, ls=:dot)
plot!(my_plot_Normal_equal, N, N01_mean_ratio_e, lab=latexstring("N(0,1)\\; \\textit{ratio\\;of\\;means}"), m=:circle, ls=:dot,
legend=:topright, theme(:mute))
scalefontsizes(1.3)
annotate!(0.9,0.9,text("",plot_font,20))
savefig(my_plot_Normal_equal, "sig_plot_equal_Normal.pdf")

default(fontfamily=plot_font, linewidth=1, framestyle=:box, label=nothing, grid=true, border=:nothing)
my_plot_Exp_equal = plot(size=(800,800))
xaxis!(my_plot_Exp_equal, (0, 5),  latexstring("N"))
yaxis!(my_plot_Exp_equal, (0.00, 0.10), latexstring("\\textit{Estimated\\; false\\; positive \\; rate}"))
plot!(my_plot_Exp_equal, N, E1_mean_diff_e, lab=latexstring("Exp(1)\\; \\textit{difference\\;in\\;means}"), m=:square, ls=:dot)
plot!(my_plot_Exp_equal, N, E1_median_diff_e, lab=latexstring("Exp(1)\\; \\textit{difference\\;in\\;medians}"), m=:circle, ls=:dot)
plot!(my_plot_Exp_equal, N, E1_quantile_diff_e, lab=latexstring("Exp(1)\\; \\textit{difference\\;in\\;90th\\;percentiles}"), m=:circle, ls=:dot)
plot!(my_plot_Exp_equal, N, E1_mean_ratio_e, lab=latexstring("Exp(1)\\; \\textit{ratio\\;of\\;means}"), m=:circle, ls=:dot)
plot!(my_plot_Exp_equal, N, E1_var_diff_e, lab=latexstring("Exp(1)\\; \\textit{difference\\;in\\;variances}"), m=:square, ls=:dot)
plot!(my_plot_Exp_equal, N, E1_var_ratio_e, lab=latexstring("Exp(1)\\; \\textit{ratio\\;of\\;variances}"), m=:circle, ls=:dot,
legend=:topright, theme(:mute))
scalefontsizes(1.3)
annotate!(0.9,0.9,text("",plot_font,20))
savefig(my_plot_Exp_equal, "sig_plot_equal_Exp.pdf")

## Results from the simulations performed with unequal increments in statistical information

# Treatment responses generated from the normal distribution

N11_mean_diff_u = [0.0626, 0.0517, 0.051, 0.0534, 0.0536]
N11_median_diff_u = [0.0442, 0.0458, 0.0469, 0.051, 0.0513]    
N11_quantile_diff_u = [0.0404, 0.0424, 0.043, 0.0492, 0.0526]
N11_mean_ratio_u = [0.0601, 0.0517, 0.051, 0.0534, 0.0536]
N01_mean_ratio_u = [0.0191, 0.0158, 0.0163, 0.0152, 0.0135]
N11_var_diff_u = [0.066, 0.0586, 0.0579, 0.0534, 0.0544]
N11_var_ratio_u = [0.066, 0.0586, 0.0579, 0.0534, 0.0544]

# Treatment responses generated from the exponetial distribution

E1_mean_diff_u = [0.0666, 0.0572, 0.0542, 0.0539, 0.0533]
E1_median_diff_u = [0.0385, 0.0477, 0.0465, 0.0513, 0.0495]
E1_quantile_diff_u = [0.0361, 0.0444, 0.0411, 0.0509, 0.0494]
E1_mean_ratio_u = [0.0666, 0.0572, 0.0542, 0.0539, 0.0533]
E1_var_diff_u = [0.0901, 0.0699, 0.0621, 0.0556, 0.0584]
E1_var_ratio_u = [0.0901, 0.0699, 0.062, 0.0556, 0.0584]

### make plots ###

default(fontfamily=plot_font, linewidth=1, framestyle=:box, label=nothing, grid=true, border=:nothing)
my_plot_Normal_unequal = plot(size=(800,800))
xaxis!(my_plot_Normal_unequal, (0, 5),  latexstring("N"))
yaxis!(my_plot_Normal_unequal, (0.00, 0.10), latexstring("\\textit{Estimated\\; false\\; positive \\; rate}"))
plot!(my_plot_Normal_unequal, N, N11_mean_diff_u, lab=latexstring("N(1,1)\\; \\textit{difference\\;in\\;means}"), m=:square, ls=:dot)
plot!(my_plot_Normal_unequal, N, N11_median_diff_u, lab=latexstring("N(1,1)\\; \\textit{difference\\;in\\;medians}"), m=:circle, ls=:dot)
plot!(my_plot_Normal_unequal, N, N11_quantile_diff_u, lab=latexstring("N(1,1)\\; \\textit{difference\\;in\\;90th\\;percentiles}"), m=:circle, ls=:dot)
plot!(my_plot_Normal_unequal, N, N11_mean_ratio_u, lab=latexstring("N(1,1)\\; \\textit{ratio\\;of\\;means}"), m=:circle, ls=:dot)
plot!(my_plot_Normal_unequal, N, N11_var_diff_u, lab=latexstring("N(1,1)\\; \\textit{difference\\;in\\;variances}"), m=:square, ls=:dot)
plot!(my_plot_Normal_unequal, N, N11_var_ratio_u, lab=latexstring("N(1,1)\\; \\textit{ratio\\;of\\;variances}"), m=:circle, ls=:dot)
plot!(my_plot_Normal_unequal, N, N01_mean_ratio_u, lab=latexstring("N(0,1)\\; \\textit{ratio\\;of\\;means}"), m=:circle, ls=:dot,
legend=:topright, theme(:mute))
scalefontsizes(1.3)
annotate!(0.9,0.9,text("",plot_font,20))
savefig(my_plot_Normal_unequal, "sig_plot_unequal_Normal.pdf")

default(fontfamily=plot_font, linewidth=1, framestyle=:box, label=nothing, grid=true, border=:nothing)
my_plot_Exp_unequal = plot(size=(800,800))
xaxis!(my_plot_Exp_unequal, (0, 5),  latexstring("N"))
yaxis!(my_plot_Exp_unequal, (0.00, 0.10), latexstring("\\textit{Estimated\\; false\\; positive \\; rate}"))
plot!(my_plot_Exp_unequal, N, E1_mean_diff_u, lab=latexstring("Exp(1)\\; \\textit{difference\\;in\\;means}"), m=:square, ls=:dot)
plot!(my_plot_Exp_unequal, N, E1_median_diff_u, lab=latexstring("Exp(1)\\; \\textit{difference\\;in\\;medians}"), m=:circle, ls=:dot)
plot!(my_plot_Exp_unequal, N, E1_quantile_diff_u, lab=latexstring("Exp(1)\\; \\textit{difference\\;in\\;90th\\;percentiles}"), m=:circle, ls=:dot)
plot!(my_plot_Exp_unequal, N, E1_mean_ratio_u, lab=latexstring("Exp(1)\\; \\textit{ratio\\;of\\;means}"), m=:circle, ls=:dot)
plot!(my_plot_Exp_unequal, N, E1_var_diff_u, lab=latexstring("Exp(1)\\; \\textit{difference\\;in\\;variances}"), m=:square, ls=:dot)
plot!(my_plot_Exp_unequal, N, E1_var_ratio_u, lab=latexstring("Exp(1)\\; \\textit{ratio\\;of\\;variances}"), m=:circle, ls=:dot,
legend=:topright, theme(:mute))
scalefontsizes(1.3)
annotate!(0.9,0.9,text("",plot_font,20))
savefig(my_plot_Exp_unequal, "sig_plot_unequal_Exp.pdf")
