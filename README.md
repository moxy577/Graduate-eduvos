Eduvos Graduate Survey Dashboard
📊 An interactive R Shiny dashboard analyzing tech tools, industries, job roles, and employment trends of Eduvos graduates.

📌 Project Overview
This dashboard was created using R Shiny to analyze data from a graduate survey conducted by Eduvos. The goal is to help Eduvos understand:

The most used programming languages, databases, AI tools, and web frameworks among graduates.
The top industries and job roles graduates enter.
The employment rate across different study fields.
The dashboard provides interactive visualizations and data insights to assist Eduvos in updating their IT courses to match industry trends.


📂 Files in This Repository
File	Description
app.R	Main R Shiny app script
graduate_survey.csv	The dataset used for analysis (optional, or provide dataset link)
README.md	Project documentation (this file)
dashboard_screenshots/	Folder containing screenshots of the dashboard (optional)

🚀 Deployment on Shinyapps.io
This dashboard has been deployed on Shinyapps.io. You can access it here:
🔗 Live Dashboard


📊 Data Processing & Cleaning
Standardized Campus Names (e.g., "Durban Campus" and "Umhlanga Campus" merged into "Durban").
Separated multiple-choice responses using tidyverse::separate_rows().
Converted categorical variables (e.g., Employment, StudyField) to factors.
