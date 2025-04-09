# 🦠 COVID-19 SQL Data Exploration Project

This project is a SQL-based analysis of global COVID-19 data, performed using MySQL Workbench. The dataset includes cases, deaths, and vaccination data sourced from the [Our World in Data](https://ourworldindata.org/coronavirus) GitHub repository. The goal is to explore trends and generate insights through SQL queries, suitable for use in visualizations and dashboards.

---

## 📁 Files

- `Covid.sql`: Main SQL script containing data transformations, CTEs, joins, temp tables, and view creation for COVID analysis.

---

## 🔍 Key Insights & Queries

The analysis includes:

- 📊 **Infection Rate vs Population**
  - Determines the percentage of population infected by country.

- ⚰️ **Death Rate**
  - Compares total deaths vs total cases to find mortality rates.

- 🌍 **Countries with Highest Death Counts**
  - Highlights countries with the most reported deaths.

- 📈 **Rolling Vaccination Count**
  - Uses window functions to calculate cumulative vaccinations by country.

- 🧮 **% Population Vaccinated**
  - Calculates the percentage of each country's population that has received at least one dose.

- 🧾 **View Creation**
  - Creates a SQL view (`percentpopulationvaccinated`) for easy integration with BI tools (e.g., Tableau, Power BI).

---

## 🛠 Technologies Used

- MySQL Workbench
- SQL (CTEs, joins, aggregate functions, window functions)
- Git & GitHub
- Visual Studio Code (for file management and version control)

---

## 📊 Potential Use Cases

- Building an interactive dashboard with Power BI or Tableau
- Practicing advanced SQL (e.g., window functions, temp tables, views)
- Showcasing SQL data analysis skills in a portfolio

---

## 🚀 How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/AmungaBrenda/covid-MYSQL-analysis.git

2. Open the Covid.sql file in MySQL Workbench.

3. Make sure you have the required coviddeaths and covidvaccinations tables in your database (PortfolioProjects schema).

4. Run the queries step-by-step to explore the data and generate insights.



🙋‍♂️ Author
Brenda Amunga
Self-learning data analyst & software developer | Passionate about insights & storytelling through data



⭐️ Show Your Support
If you found this useful, please give this repo a ⭐️ on GitHub!

---

Let me know if you'd like to:

- Add images or charts from Tableau/Power BI
- Link to your live dashboard
- Generate a `LICENSE` file for open-source compliance
- Include a SQL diagram or ERD of the tables used

Ready to make this repo shine! ✨
