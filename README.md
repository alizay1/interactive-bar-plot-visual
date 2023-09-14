# Interactive Bar Plot Visual

During grad school, my data visualization course participated in the 2022 NISS SAID data visualization competition found [here](https://www.niss.org/events/niss-statistically-accurate-interactive-displays-graphics-0). I collaborated with a couple of other classmates to create one complete dashboard using the data provided by NISS. The team split up tasks and the interactive bar plot displayed here on GitHub is the graphic that I was responsible for creating. I decided to make it a standalone dashboard so you can access it [here](https://alizay1.shinyapps.io/interactive-bar-plot-of-education-data/).




## The Data

The first dataset found [here](https://nces.ed.gov/programs/digest/d20/tables/dt20_603.10.asp) contains the percentage of the population who completed high school by age group and country from 2000 to 2019. 

The second dataset found [here](https://nces.ed.gov/programs/digest/d20/tables/dt20_603.20.asp) contains the same information as the first except it is for the percentage of the population that attained any postsecondary degree after high school.

In both tables, the population percentages are from OECD (Organisation for Economic Co-operation and Development) participating countries. The OECD average is also displayed which averages out all the countries population percentages by year and age group.

For 2018 and 2019, the standard errors were  estimated by NCES (National Center for Education Statistics).


**Note: Both tables were combined then cleaned for the project so some countries will be missing some data in the visualization.**


## Description of Visual


When you open up the dashboard, the base visual is shown under the "All Age Ranges" selection. It does a side by side comparison of high school completion and postsecondary completion percentages by age group.

![Screenshot 2023-09-12 at 4 28 24 PM](https://github.com/alizay1/interactive-bar-plot-visual/assets/101383537/dd2d390d-fd3d-4785-97cf-5067007c09af)

***




![Screenshot 2023-09-12 at 4 30 48 PM](https://github.com/alizay1/interactive-bar-plot-visual/assets/101383537/b0edf4f1-c441-41b3-aa39-d412c2d52691)



***

![Screenshot 2023-09-12 at 4 31 06 PM](https://github.com/alizay1/interactive-bar-plot-visual/assets/101383537/3505fbe1-2566-4762-827e-812bf26b41c4)



### Standard Instructions
1. Select one of the OECD countries to view on the left hand side.
2. Toggle between the age groups in the dropdown menu located on the right hand side of the dashboard.
3. Select or deselect any of the values displayed in the legend for less obvious comparisons.
4. Hover over any bar to get the exact population percentage with the standard error.

**Note: Only the age ranges from 25-34 and 25-64 were used for all years.**

## Questions to Answer

1. How has the high school and postsecondary degree completion percentages change over time?
2. How has each country performed compared to the OECD average for each age group?

***


### Based on the questions asked (or questions of your own), see if you can come up with your own conclusions!







