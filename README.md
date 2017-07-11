如果你想用R来完成单个率的荟萃分析（meta-analysis），那你来对地方了。

我在此提供四套模板供感兴趣的学生、学者使用。你可以用我的模板轻松完成荟萃分析的统计部分。

一般来讲，当你把你的数据导入R之后，你需要根据数据的性质决定采用哪种数据转换方式，最常用的有三种方式：不进行转换、logit转换、double arcsine转换。我的三个模板分别对应这三种转换方法，并使用真实数据呈现完成荟萃分析的每一个步骤。在第四个模板中，我使用模拟数据呈现完成荟萃回归分析（meta-regression）的所有步骤。

我的模板可以计算平均效应量、分组效应量、绘制树状图、检验异质性、进行小组分析和荟萃回归分析、绘制漏斗图以及对发表偏倚进行检测。你只需要按照要求把数据文件整理好然后按照你自己的需求更改模板里的代码选项即可。

我们主要使用R中的metafor程序包来完成荟萃分析。我也会提供用meta程序包完成荟萃分析的模板。这两者有什么不同呢？前者像是你自己用纸笔进行计算，每一步都要自己计算；后者就像一个计算器，你只需要导入数据文件并更改几个计算选项就可以得到跟前者完全一样的结果。不过二者各有利弊。

通过我的模板计算出的结果跟其他几款荟萃分析统计软件得到的结果完全一样（包括Stata和Comprehensive Meta-Analysis）。那为什么不用其他软件实现荟萃分析而要使用R和我的模板呢？最大的原因是：1.R软件是免费的。当然，对于中国学生学者来说，Stata也是免费的（盗版破解），不过对外国人来讲，Stata即使是学生价也要198刀（终身使用价）；CMA的价格为195刀。2.R提供的统计功能比其他软件更加全面。CMA仅提供logit转换。Revman的统计功能也不如R全面。

最后，讲一讲我为什么要编写这四套模板。
第一，虽然R中提供了进行荟萃分析的各种软件包（应用最广泛的就是metafor），并且软件包的作者撰写了使用说明，但这仅仅是对软件包的使用说明。在之前，如果一个荟萃分析的初学者想完成自己的第一个荟萃分析，他需要从头将软件包的使用说明读一遍，且不能保证读完就会使用软件包中的代码。我的模板是非常有针对性的，并解释了每一组代码的功能。就像我上面写的，你只需要将数据导入即可完成达到发表水平的统计分析。
第二，在几年前曾有中南大学的研究生、四川大学的研究生以及北京大学的研究生发表过如何在R、Revman、Stata中实现荟萃分析的期刊论文。这三篇期刊论文中，有的代码过于简单、不全面，没法在复杂情况下应用；有的文章中出现不应该出现的概念性错误，说明作者对荟萃分析的理解有所欠缺；有的作者选择的实例不具代表性。
我的模板中选用的实例是我对36个发表的荟萃分析研究进行统计再现后精挑细选出来的，通过对每个实例的学习可以帮助你很快掌握荟萃分析的基本分析步骤。
总之，我的目的是帮助不懂荟萃分析统计过程以及对统计过程不感兴趣只想立刻得到统计结果的学生和学者们，让他们在很短的时间内完成统计分析。

将来的计划是实现这四套模板中的代码的可视化。也就是说，你使用我的模板时，根本不会看到任何代码，只需要像使用SPSS一样点击按钮选项即可。

代码会在日后不久首先在GitHub上公开。希望我能尽我所力，帮你减轻一点统计分析的痛苦：）


In this "metaprops" repository, I provide four rmd. files along with three real-life data sets and a simulated data set here as templates for conducting meta-analyses of proportions. 

The first template gives an example of how to conduct a meta-analysis of proportions with the logit transformation.
The second template gives an example of how to conduct a meta-analysis of proportions with the Freeman-Tukey double arcsine transformation.
The third template gives an example of how to conduct a meta-analysis of proprotions without performing a transformation.
These are three most commonly used transformation methods in the literatures. Personally, I have never seen any authors performing an arcsine transformation in their meta-analysis studies.
The last template employs a simuated data set I created in order to teach you how to conduct meta-regressions.  

The metafor package is our primary tool to do the work. I will also provide a template for conducting meta-analyses of proportions with the meta package. But, we will mainly focus on the metafor package.

With my templates, you can calculate average effect sizes, subgroup effect sizes, create forest plots, examine heterogeneity, conduct moderator analysis, perform meta-regressions, create funnel plots, conduct tests for publication bias, including trim and fill, Egger's test, Begg's rank correlation test, and Vevea and Hedges (1995) Weight-Function Model. You name it. The only thing you need to do is format your data as instructed and personalize the parameters in the templates. 

The results yielded by my templates are in accordance with those yielded by the meta package, Comprehensive Meta-Analysis, and Stata. Actually, they yiled exactly the same results.

Enjoy my templates:)
