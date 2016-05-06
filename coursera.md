### Documentation for Medicare Expense for an episode

This App is intented to show the Medicare expenses per episode. Data was
obtained from [Spending Per Hospital
Patient](https://www.medicare.gov/hospitalcompare/Data/spending-per-hospital-patient.html).
For understanding of the terminology used in this app refer to the
[Fact-Sheet-MSPB-Spending-Breakdowns-by-Claim-Type-Dec-2014.pdf](https://www.cms.gov/Medicare/Quality-Initiatives-Patient-Assessment-Instruments/hospital-value-based-purchasing/Downloads/Fact-Sheet-MSPB-Spending-Breakdowns-by-Claim-Type-Dec-2014.pdf)

-   Shiny Application : <https://bvsrini.shinyapps.io/coursera/>

-   GitHub Page :
    [Code](https://github.com/bvsrini/Data-Products/tree/master)

-   Presentation : <http://rpubs.com/bvsrini/MedicareApp>

### Instructions

1.  Choose either a "Claim Type" , "Period" or both to see the
    comparison map betweeen State's average Medicare spending by episode
    in USD and Nation's average Medicare spending by episode
    1.  The colors on the map in the "Summary" tab should differentiate
        if for the user selections the spending is higher,lower or equal
        to the Nation's Average. In some cases there is no data.
    2.  Selecting a "State" does not affect the "Summary" tab.
    3.  A map should appear with the initial selections by default.
        However it does take a little while to show up.if you make a
        selection the data does appear faster.

2.  Choose either a "Claim Type" , "Period" , "State" or all to see the
    detail "Medicare Data" or to see the Heat map by state.
3.  You can navidate the data or filter them through column wise search
    or table search options in the table.
4.  The data in the heat map is displayed at a hospital level. It
    indicates the spending by episode for these hospitals based on
    various "Claim Type" and "Periods"
    1.  The darker blue indicates a higher spending while light cream
        color indicates a lower spending.
    2.  The heat map is arranged by means of the columns so you can
        easily see which "Claim Type" and "Period" have the most
        spending  
    3.  The column names are abbreviated for lack of real estate in
        the plot. Column names are concatenation of "Claim
        Type"and "Period". All the columns represent "Average Spending
        for an episode in an Hospital". Here are details

        <table style="width:97%;">
        <colgroup>
        <col width="18%" />
        <col width="63%" />
        <col width="15%" />
        </colgroup>
        <thead>
        <tr class="header">
        <th align="left">Column part</th>
        <th align="left">Expansion</th>
        <th align="left">Refers to</th>
        </tr>
        </thead>
        <tbody>
        <tr class="odd">
        <td align="left">HHA</td>
        <td align="left">Home Health Agency</td>
        <td align="left">Claim Type</td>
        </tr>
        <tr class="even">
        <td align="left">Hospice</td>
        <td align="left">Hospice</td>
        <td align="left">Claim Type</td>
        </tr>
        <tr class="odd">
        <td align="left">inpatient</td>
        <td align="left">inpatient</td>
        <td align="left">Claim Type</td>
        </tr>
        <tr class="even">
        <td align="left">Outpatient</td>
        <td align="left">Outpatient</td>
        <td align="left">Claim Type</td>
        </tr>
        <tr class="odd">
        <td align="left">SNF</td>
        <td align="left">Skilled Nursing Facility</td>
        <td align="left">Claim Type</td>
        </tr>
        <tr class="even">
        <td align="left">DME</td>
        <td align="left">Durable Medical Equipment</td>
        <td align="left">Claim Type</td>
        </tr>
        <tr class="odd">
        <td align="left">Carrier</td>
        <td align="left">Carrier</td>
        <td align="left">Claim Type</td>
        </tr>
        <tr class="even">
        <td align="left">P13</td>
        <td align="left">1 to 3 days Prior to Index Hospital Admission</td>
        <td align="left">Period</td>
        </tr>
        <tr class="odd">
        <td align="left">DH</td>
        <td align="left">During Index Hospital Admission</td>
        <td align="left">Period</td>
        </tr>
        <tr class="even">
        <td align="left">A130</td>
        <td align="left">1 through 30 days After Discharge from Index</td>
        <td align="left">Period</td>
        </tr>
        <tr class="odd">
        <td align="left"></td>
        <td align="left">Hospital Admission</td>
        <td align="left"></td>
        </tr>
        <tr class="even">
        <td align="left">$</td>
        <td align="left">Avg Spending Per Episode (Hospital) in USD</td>
        <td align="left">Metric</td>
        </tr>
        </tbody>
        </table>

### Data Considerations and Processing

1.  The Medicare spending data is computed based on the inputs entered
    by the user as described above

2.  For the "Summary" map tab, data for all the claim Types and Periods
    except "Complete Episode" and "Total" were not considered since the
    data desired is at an individual claim type and a Period. The "Avg
    Spending Per Episode (State)" was considered for the plot. Here the
    provider\_number was ignored.

3.  For the "Heat Map" data for all the claim Types and Periods except
    "Complete Episode" and "Total" were not considered since the data
    desired is at an individual claim type and a Period. The "Avg
    Spending Per Episode (Hosp)" was considered for the plot. Here the
    provider\_number was ignored.Where there were duplicates Max
    spending of all providers was considered.
