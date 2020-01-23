<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Fencing Time
By Daniel Berke
(C) Copyright by Daniel Berke 
-->
<!-- Tournament export to html -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ft="http://www.fencingtime.com">
  <xsl:output indent="yes" encoding="UTF-8" omit-xml-declaration="yes" method="html" />
  <xsl:variable name="fileVersion">4.4</xsl:variable>

  <xsl:param name="langCode" />
  <xsl:param name="langFile" />
  
  <xsl:variable name="localized" select="document($langFile)/ft:LocalizedText" />
  
  <!-- Main template matching rule -->
  <xsl:template match="/ft:EventSnapshot">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"&gt;</xsl:text>  
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>   
        <meta http-equiv="Content-Language" content="{$langCode}" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>
          <xsl:value-of select="ft:EventInfo/@TournamentName" />
        </title>
        <style type="text/css">
            body {
                font-size:          .80em; 
                font-family:        'Segoe UI', Arial, Helvetica, Verdana, sans-serif; 
                margin:             16px; 
                padding:            0px; 
            }
            .pageFooter {
                margin-top:         4px;
                color:              #222222;
                text-align:         center;
            }

            .pageHeader {
                background:         #4B6C9E;
                margin-bottom:      8px;
                color:              #F9F9F9;
                font-variant:       small-caps;
                text-align:         left;
                padding:            8px;
            }   
            .tournName {   
                font-size:          2em;
                font-weight:        bold
                line-height:        1.2em;
            }
            .tournDetails {
                font-size:          1.2em;
                margin-top:         4px;
            }
            .roundName
            {
                font-size:          1.8em;
                color:              #444444;
                font-variant:       small-caps;
                text-transform:     none;
                margin-bottom:      4px;
            }

            .dataTable {
                border:             solid 1px tan;
                border-collapse:    collapse;
                font-size:          1em;
                line-height:        1.5em;
                width:              100%;
                vertical-align:     top;
                text-align:         left;
                font-style:          normal;
            }
            .dataTable td {
                padding:            3px;
            }
            .dataTableHeaderRow {
                font-weight:        bold;
                background:         tan;
            }
            .dataTableOddRow {
                background:         #FAFAD2;
            }
            .dataTableEvenRow {
                background:         #EEE8AA;
            }
            .dataTableExcludedRow {
                background:         #333333;
                color:              #FFFFFF;
            }
            .dataTableGoldResultRow {
                background:         #FFD700;
            }
            .dataTableSilverResultRow {
                background:         #888888;
                color:              #FFFFFF;
            }
            .dataTableBronzeResultRow {
                background:         #A67D3D;
                color:              #FFFFFF;
            }
            
          .poolNum {
              font-size:            1.4em;
              color:                #666666;
              font-variant:         small-caps;
              text-transform:       none;
              margin-bottom:        0px;
              font-family:          Tahoma, serif
          } 
          .pool { 
              color:                #000000;
              border:               solid 1px #D2B48C; 
              border-collapse:      collapse;
              font-size:            1em;
              line-height:          1.5em;
          }
          .pool td {
              padding:              1px 2px 1px 2px;
              border-right:         solid 1px #D2B48C;
              border-bottom:        solid 1px #D2B48C;
              height:               40px;
              font-style:            normal;
          }
          .poolHeader {
              background-color:     #D2B48C; 
              font-weight:          bold;
          }
          .poolHeader th {
              font-weight:           bold;
              text-align:           center;
              vertical-align:       top;
              font-style:            normal;
          }
          .poolOddRow {
              background-color:     #FAFAD2;
              vertical-align:       middle;
          }
          .poolEvenRow {
              background-color:     #EEE8AA;
              vertical-align:       middle;
          }
          .poolNameCol {
              padding:              2px;
              min-width:            256px;
          }
          .poolPosCol {
              background-color:     #D2B48C; 
              font-weight:          bold;
              text-align:           center;
              width:                15px;
          }
          .poolScoreCol {
              min-width:            40px;
              font-size:            1.3em;
              text-align:            center;
              vertical-align:        middle;
              font-weight:          normal;
          }
          .poolSpacerCol {
              background-color:     #D2B48C;
              width:                10px;
          } 
          .poolResultCol {  
              text-align:           center;
              min-width:            40px;
              font-size:            1.3em;
          }
          .poolScoreFill {
              background-color:     #695A46;
          } 
          .poolWithdrawn { 
              background-color:     #AAAAAA;
          } 
          .poolExcluded {
              background-color:     #AAAAAA;
          }
          .poolScoreVictory { 
              text-align:           center;
              background-color:     #88FF88;
          } 
          .poolScoreDefeat { 
              text-align:           center;
              background-color:     #FF8888;
          }
          .poolRefsDiv {
              margin-top:           4px;
              color:                #0000FF;
          }
          .poolRefsHeader {
              font-size:            1.0em;
              font-weight:          bold;
              font-variant:         small-caps;
              font-family:          Tahoma, serif;
              text-transform:       none;
          }                         
          .poolRefName {            
              color:                #0000FF;
          }
            
          .elimTableau {
              color:                #000000;
              background-color:     #FAFAD2;
              border:               solid 1px #D2B48C; 
              border-collapse:      collapse;
              font-size:            1em;
          } 
          .elimTableu td {  
            border-width:           0px;
          } 
          .tableauColumnTitle { 
              text-align:           center;
              font-weight:          bold;
              background:           #D2B48C;
              font-size:            1em;
              line-height:          1.5em;
          } 
          .tableauBorderRight { 
              border-right:         solid 2px #222222;
          } 
          .tableauBorderLeft {  
              border-left:          solid 2px #222222;
          }
          .tableauBorderLeftRight {
              border-left:          solid 2px #222222;
              border-right:         solid 2px #222222;
          }
          .tableauBorderBottom {
              border-bottom:        solid 2px #222222;
              vertical-align:       bottom;
          }
          .tableauBorderBottomRight {
              border-bottom:        solid 2px #222222;
              border-right:         solid 2px #222222;
              vertical-align:       bottom;
          }
          .tableauBorderBottomLeft {
              border-bottom:        solid 2px #222222;
              border-left:          solid 2px #222222;
              vertical-align:       bottom;
          }
          .tableauBorderBottomLeftRight {
              border-bottom:        solid 2px #222222;
              border-left:          solid 2px #222222;
              border-right:         solid 2px #222222;
              vertical-align:       bottom;
          }
          .tableauNameCell {
              font-size:            .85em;
          }   
          .tableauSeed {   
              font-weight:          bold;
              color:                #000000;
          }   
          .tableauCompName {   
              font-weight:          bold;
              color:                #0000FF;
          }
          .tableauCompAffil {
              color:                #666666;
              font-size:            0.8em;
              vertical-align:       top;
          }   
          .tableauReferee {   
              color:                #666666;
              font-size:            0.8em;
              vertical-align:       top;
          }
          
          .tableauMatchDetailsLink a {
              color:                black;
              font-size:            0.8em;
              font-variant:         small-caps;
              text-decoration:      none;
              font-weight:          bold
          }
          .teamMatch {
              margin-top:           16px;
          }
          .teamMatchName {
              font-size:            1.4em;
              color:                #666666;
              font-variant:         small-caps;
              text-transform:       none;
              margin-bottom:        0px;
          }
          .teamMatchNumCol {
              border-right:         solid 1px #D2B48C;
              text-align:           center;
              width:                7%;
          }
           .teamMatchNameCol {
              border-right:         solid 1px #D2B48C;
              text-align:           center;
              width:                30%;
          } 
          .teamMatchTouchesCol { 
              border-right:         solid 1px #D2B48C;
              text-align:           center;
              width:                5%;
          } 
          .teamMatchScoreCol 
          { 
              border-right:         solid 1px #D2B48C;
              text-align:           center;
              width:                8%;
          } 
          .teamMatchRefs { 
              margin-top:           4px;
              color:                #0000FF;
          }
        </style>
      </head>

      <body>
        <!-- Page header -->
        <div class="pageHeader">
          <span class="tournName"><xsl:value-of select="ft:EventInfo/@TournamentName" /></span>
          <br />
          <br />
          <span class="tournDetails">
            <xsl:value-of select="ft:EventInfo/@Name" /><br />
            <xsl:value-of select="ft:EventInfo/@Date" />
            <xsl:text xml:space="preserve"> - </xsl:text>
            <xsl:value-of select="ft:EventInfo/@Time" />
          </span>
        </div>

        <!-- Final results -->
        <div>
          <div class="roundName"><xsl:value-of select="$localized/ft:LocText[@id='FinalResults']" /></div>
          <xsl:if test="ft:FinalResults/@EventClass">
            <div class="finalResultsEventClass">
              Event classification: <xsl:value-of select="ft:FinalResults/@EventClass" />
            </div>
          </xsl:if>
          
          <xsl:call-template name="RenderResults">
            <xsl:with-param name="results" select="ft:FinalResults" />
            <xsl:with-param name="evType"  select="ft:EventInfo/@Type" />
          </xsl:call-template>
          
          <xsl:if test="ft:FinalResults/@IncludeRatingNote">
            <div class="finalResultsRatingsNote">
              <sup>*</sup>Earned classifications are not official until recorded by the National Office.
            </div>
          </xsl:if>
        </div>
      
        <xsl:for-each select="ft:RoundList/ft:Round">
          <br/>
          <br/>
          <div>
            <div class="roundName">
              <xsl:value-of select="@Name"/>
              <xsl:text xml:space="preserve"> - </xsl:text><xsl:value-of select="$localized/ft:LocText[@id='RoundSeeding']" />
            </div>
            
            <xsl:call-template name="RenderSeeding">
              <xsl:with-param name="seeding"  select="ft:Seeding" />
              <xsl:with-param name="roundNum" select="@Number" />
              <xsl:with-param name="evType"   select="../../ft:EventInfo/@Type" />
            </xsl:call-template>
            
            <br />

            <div class="roundName">
              <xsl:value-of select="@Name"/>
              <xsl:text xml:space="preserve"> - </xsl:text><xsl:value-of select="$localized/ft:LocText[@id='Scores']" />
            </div>

            <xsl:choose>
              <xsl:when test="@Type='Pool'">
                <xsl:for-each select="ft:Scores/ft:Pool">
                  <xsl:call-template name="RenderPool" />
                  <br/>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="@Type='Elimination'">
                <xsl:call-template name="RenderTableau" />
              </xsl:when>
            </xsl:choose>
          </div>
        </xsl:for-each>
        
        <div class="pageFooter">
          <xsl:value-of select="$localized/ft:LocText[@id='GeneratedBy']" />&#160;Fencing Time v<xsl:value-of select="@ftversion" />&#160;<xsl:value-of select="$localized/ft:LocText[@id='TournSW']" /><br/> 
          <a href="http://www.fencingtime.com">www.FencingTime.com</a><br/>
          Copyright © 2018 by Fencing Time, LLC
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="RenderResults">
    <xsl:param name="results" />
    <xsl:param name="evType"  />
    
    <table class="dataTable">
      <!-- Table header row -->
      <tr class="dataTableHeaderRow">
        <th><xsl:value-of select="$localized/ft:LocText[@id='Place']" /></th>
        <th><xsl:value-of select="$localized/ft:LocText[@id='Name']" /></th>
        <xsl:if test="$results/*/@MemNum">
          <th><xsl:value-of select="$localized/ft:LocText[@id='MemNum']" /></th>
        </xsl:if>
        <xsl:if test="$results/*/@ClubFull">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Clubs']" /></th>
        </xsl:if>
        <xsl:if test="$results/*/@Division">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Division']" /></th>
        </xsl:if>
        <xsl:if test="$results/*/@Country">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Country']" /></th>
        </xsl:if>
        <xsl:if test="$results/*/@Rating">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Class']" /></th>
        </xsl:if>
        <xsl:if test="$results/*/@Earned">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Earned']" /><sup>*</sup></th>
        </xsl:if>
        <xsl:if test="$results/*/@Members">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Members']" /></th>
        </xsl:if>
        <xsl:if test="$results/*/@Qualified">
          <th><xsl:value-of select="$localized/ft:LocText[@id='QualFor']" /></th>
        </xsl:if>
      </tr>
    
      <xsl:for-each select="$results/ft:Result">
        <tr>
          <xsl:choose>
            <xsl:when test="@Excluded">
              <xsl:attribute name="class">dataTableExcludedRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="@Place='1' or @Place='1T'">
              <xsl:attribute name="class">dataTableGoldResultRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="@Place='2' or @Place='2T'">
              <xsl:attribute name="class">dataTableSilverResultRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="@Place='3' or @Place='3T'">
              <xsl:attribute name="class">dataTableBronzeResultRow</xsl:attribute>
            </xsl:when>            
            <xsl:when test="position() mod 2 = 1">
              <xsl:attribute name="class">dataTableOddRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="position() mod 2 = 0">
              <xsl:attribute name="class">dataTableEvenRow</xsl:attribute>
            </xsl:when>
          </xsl:choose>
          
          <td>
            <xsl:value-of select="@Place" />
          </td>
          
          <td>
            <xsl:choose>
              <xsl:when test="@Excluded and $evType = 'Team'"><xsl:value-of select="$localized/ft:LocText[@id='TeamExcluded']" /></xsl:when>
              <xsl:when test="@Excluded and $evType = 'Individual'"><xsl:value-of select="$localized/ft:LocText[@id='FencerExcluded']" /></xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@Name" />
              </xsl:otherwise>
            </xsl:choose>
          </td>
          
          <xsl:if test="$results/*/@MemNum">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@MemNum" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$results/*/@ClubFull">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@ClubFull" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$results/*/@Division">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Division" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$results/*/@Country">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Country" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$results/*/@Rating">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Rating" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>

          <xsl:if test="$results/*/@Earned">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Earned" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>

          <xsl:if test="$results/*/@Members">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Members" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>

          <xsl:if test="$results/*/@Qualified">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Qualified" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  
  <xsl:template name="RenderSeeding">
    <xsl:param name="seeding"  />
    <xsl:param name="roundNum" />
    <xsl:param name="evType"   />

    <table class="dataTable">
      <!-- Table header row -->
      <tr class="dataTableHeaderRow">
        <th><xsl:value-of select="$localized/ft:LocText[@id='Seed']" /></th>
        <th><xsl:value-of select="$localized/ft:LocText[@id='Name']" /></th>
        <xsl:if test="$seeding/*/@Rating">
          <th><xsl:value-of select="$localized/ft:LocText[@id='ClassRank']" /></th>
        </xsl:if>
        <xsl:if test="$seeding/*/@TeamPoints">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Points']" /></th>
        </xsl:if>
        <xsl:if test="$seeding/*/@TeamRank">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Rank']" /></th>
        </xsl:if>
        <xsl:if test="$seeding/*/@Members">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Members']" /></th>
        </xsl:if>
        <xsl:if test="$seeding/*/@Club">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Clubs']" /></th>
        </xsl:if>
        <xsl:if test="$seeding/*/@Division">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Division']" /></th>
        </xsl:if>
        <xsl:if test="$seeding/*/@Country">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Country']" /></th>
        </xsl:if>
        <xsl:if test="$seeding/*/@V">
          <th>V</th>
          <th>V/M</th>
          <th><xsl:value-of select="$localized/ft:LocText[@id='TS']" /></th>
          <th><xsl:value-of select="$localized/ft:LocText[@id='TR']" /></th>
          <th>Ind</th>
        </xsl:if>       
        <xsl:if test="$roundNum &gt; 0">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Status']" /></th>
        </xsl:if>
      </tr>

      <!-- Competitor rows -->
      <xsl:for-each select="$seeding/ft:Competitor">
        <tr>
          <xsl:choose>
            <xsl:when test="@Excluded">
              <xsl:attribute name="class">dataTableExcludedRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="position() mod 2 = 1">
              <xsl:attribute name="class">dataTableOddRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="position() mod 2 = 0">
              <xsl:attribute name="class">dataTableEvenRow</xsl:attribute>
            </xsl:when>
          </xsl:choose>
          
          <td>
            <xsl:value-of select="@Seed" />
          </td>
          
          <td>
            <xsl:choose>
              <xsl:when test="@Excluded and $evType = 'Team'"><xsl:value-of select="$localized/ft:LocText[@id='TeamExcluded']" /></xsl:when>
              <xsl:when test="@Excluded and $evType = 'Individual'"><xsl:value-of select="$localized/ft:LocText[@id='FencerExcluded']" /></xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@Name" />
              </xsl:otherwise>
            </xsl:choose>
          </td>
          
          <xsl:if test="$seeding/*/@Rating">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Rating" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$seeding/*/@TeamPoints">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@TeamPoints" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>

          <xsl:if test="$seeding/*/@TeamRank">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@TeamRank" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$seeding/*/@Members">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Members" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$seeding/*/@Club">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Club" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$seeding/*/@Division">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Division" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$seeding/*/@Country">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Country" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$seeding/*/@V">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@V" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@VM" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@TS" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@TR" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Ind" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>

          <xsl:if test="$roundNum &gt; 0">
            <td>
              <xsl:choose>
                <xsl:when test="@Exempt">
                  <span class="statusAdvanced"><xsl:value-of select="$localized/ft:LocText[@id='Exempt']" /></span>
                </xsl:when>
                <xsl:when test="@Excluded">
                  <span class="statusElim"><xsl:value-of select="$localized/ft:LocText[@id='Excluded']" /></span>
                </xsl:when>
                <xsl:when test="@Eliminated">
                  <span class="statusElim"><xsl:value-of select="$localized/ft:LocText[@id='Eliminated']" /></span>
                </xsl:when>
                <xsl:when test="$roundNum &gt; 1">
                  <span class="statusAdvanced"><xsl:value-of select="$localized/ft:LocText[@id='Advanced']" /></span>
                </xsl:when>
              </xsl:choose>
            </td>
          </xsl:if>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  
  <xsl:template name="RenderPool">
    <div class="poolNum">
      <xsl:value-of select="$localized/ft:LocText[@id='PoolNum']" /><xsl:value-of select="@Number" />
    </div>
  
    <table class="pool">
      <tr class="poolHeader">
        <th></th>
        <th>#</th>

        <!-- Score columns for each competitor -->
        <xsl:for-each select="ft:Competitors/ft:Competitor">
          <th>
            <xsl:value-of select="@Position" />
          </th>
        </xsl:for-each>

        <th></th>
        <th>V</th>
        <th>V/M</th>
        <th><xsl:value-of select="$localized/ft:LocText[@id='TS']" /></th>
        <th><xsl:value-of select="$localized/ft:LocText[@id='TR']" /></th>
        <th>Ind</th>
      </tr>
  
      <!-- Create a row for each competitor -->
      <xsl:for-each select="ft:Competitors/ft:Competitor">
        <xsl:variable name="thisComp" select="." />
                
        <tr>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="@IsWithdrawn">poolWithdrawn</xsl:when>
              <xsl:when test="@IsExcluded">poolExcluded</xsl:when>
              <xsl:when test="position() mod 2 = 0">poolEvenRow</xsl:when>
              <xsl:otherwise>poolOddRow</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>

          <!-- Name, rating, and affiliations -->
          <td class="poolNameCol">
            <xsl:value-of select="@Name" />
            
            <xsl:if test="@Club != '' or @Division != '' or @Country != ''">
              <br/>
              <span class="poolAffil">
                <xsl:call-template name="BuildAffiliations">
                  <xsl:with-param name="clubAbbr"    select="@Club" />
                  <xsl:with-param name="divAbbr"     select="@Division" />
                  <xsl:with-param name="countryAbbr" select="@Country" />
                </xsl:call-template>
              </span>
            </xsl:if>
          </td>

          <!-- Position -->
          <xsl:variable name="rowPos" select="@Position" />
          <td class="poolPosCol">
            <xsl:value-of select="$rowPos" />
          </td>

          <!-- Create score column for each opponent -->
          <xsl:for-each select="../../ft:Competitors/ft:Competitor">
            <xsl:variable name="colPos" select="@Position" />
            <td>
              <xsl:variable name="scoreVal" select="$thisComp/ft:Scores/ft:Score[number($colPos)]/@Value" />
              <xsl:choose>
                <xsl:when test="$colPos = $rowPos">   <!-- Filler on the diagonal -->
                  <xsl:attribute name="class">poolScoreFill poolScoreCol</xsl:attribute>
                </xsl:when>
                <xsl:when test="starts-with($scoreVal, 'V')">
                  <xsl:attribute name="class">poolScoreVictory poolScoreCol</xsl:attribute>
                  <xsl:value-of select="$scoreVal" />
                </xsl:when>
                <xsl:when test="starts-with($scoreVal, 'D')">
                  <xsl:attribute name="class">poolScoreDefeat poolScoreCol</xsl:attribute>
                  <xsl:value-of select="$scoreVal" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">poolScoreCol</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </td>                          
          </xsl:for-each>

          <td class="poolSpacerCol" />
                  
          <!-- Result columns -->
          <td class="poolResultCol">
            <xsl:value-of select="$thisComp/@V" />
          </td>
          <td class="poolResultCol">
            <xsl:value-of select="$thisComp/@WinPct" />
          </td>
          <td class="poolResultCol">
            <xsl:value-of select="$thisComp/@TS" />
          </td>
          <td class="poolResultCol">
            <xsl:value-of select="$thisComp/@TR" />
          </td>
          <td class="poolResultCol">
            <xsl:value-of select="$thisComp/@Ind" />
          </td>
        </tr>
      </xsl:for-each>
    </table>
  
    <!-- Pool referees, if any -->
    <xsl:if test="ft:Referees/ft:Referee">
      <div class="poolRefsDiv">
        <span class="poolRefsHeader"><xsl:value-of select="$localized/ft:LocText[@id='Referees']" /></span>
        <br/>
        <xsl:for-each select="ft:Referees/ft:Referee">
          <span class="poolRefName">
            <xsl:value-of select="@Name" />
          </span>
          <br />
          <xsl:if test="@Club != '' or @Division != '' or @Country != ''">
            <span class="poolAffil">
              <xsl:call-template name="BuildAffiliations">
                <xsl:with-param name="clubAbbr"    select="@Club" />
                <xsl:with-param name="divAbbr"     select="@Division" />
                <xsl:with-param name="countryAbbr" select="@Country" />
              </xsl:call-template>
            </span>
            <br/>
          </xsl:if>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <!-- Template to render DE tableau -->
  <xsl:template name="RenderTableau">
    <xsl:variable name="elimType" select="ft:Scores/ft:Elimination/@ElimType" />
    <div>
      <xsl:for-each select="ft:Scores/ft:Elimination/ft:Tree">
        <xsl:sort select="@Order" data-type="number" />
        <xsl:call-template name="RenderElimTableau">
          <xsl:with-param name="startTableSize" select="@StartSize" />
          <xsl:with-param name="endTableSize"   select="@EndSize" />
        </xsl:call-template>
      </xsl:for-each>
    
      <p>
        <xsl:for-each select="ft:Scores//ft:TeamMatch">
          <xsl:call-template name="RenderTeamMatch" />
        </xsl:for-each>
      </p>
    </div>
  </xsl:template>
  
  <!-- Template to render DE tableau -->
  <xsl:template name="RenderElimTableau">
    <xsl:param name="startTableSize" />
    <xsl:param name="endTableSize" />

    <!-- Count number of columns -->
    <xsl:variable name="numCols">
      <xsl:call-template name="CountCols">
        <xsl:with-param name="startSize" select="$startTableSize" />                
        <xsl:with-param name="endSize"   select="$endTableSize" />  
        <xsl:with-param name="curCount"  select="0" />
      </xsl:call-template>
    </xsl:variable>
    
    <table class="elimTableau">
      <xsl:attribute name="style">
        <xsl:choose>
          <xsl:when test="$numCols = 2">width: 40%;</xsl:when>
          <xsl:when test="$numCols = 3">width: 60%;</xsl:when>
          <xsl:when test="$numCols = 4">width: 80%;</xsl:when>
          <xsl:otherwise>width: 100%;</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <!-- Create column widths -->
      <xsl:call-template name="RenderTableauColumnWidths">
        <xsl:with-param name="numCols" select="$numCols" />
        <xsl:with-param name="percent" select="100 div $numCols" />
      </xsl:call-template>
      
      <!-- Create column headers -->
      <tr>
        <xsl:call-template name="RenderTableauHeader">
          <xsl:with-param name="tables"     select="ft:Table" />
          <xsl:with-param name="curColSize" select="$startTableSize" />
          <xsl:with-param name="sizeDelta"  select="0.5" />
          <xsl:with-param name="numTables"  select="$numCols - 1" />
        </xsl:call-template>
      </tr>

      <!-- Create blank row -->
      <tr>
        <xsl:call-template name="RenderTableauBlankRow">
          <xsl:with-param name="numCols" select="$numCols" />
        </xsl:call-template>
      </tr>

      <!-- Create tableau rows -->
      <xsl:call-template name="RenderElimTableRow">
        <xsl:with-param name="tableSize"   select="$startTableSize" />
        <xsl:with-param name="endColSize"  select="$endTableSize" />
        <xsl:with-param name="curRowNum"   select="0" />
      </xsl:call-template>
    </table>
    <br />
  </xsl:template>

  
  <!-- Create table col elements -->
  <xsl:template name="RenderTableauColumnWidths">
    <xsl:param name="numCols" />
    <xsl:param name="percent" />

    <xsl:if test="$numCols &gt; 0">
      <col style="width: {$percent}%; max-width:200px;" />
      <xsl:call-template name="RenderTableauColumnWidths">
        <xsl:with-param name="numCols" select="$numCols - 1" />
        <xsl:with-param name="percent" select="$percent" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <!-- Create headers for each column of the tableau -->
  <xsl:template name="RenderTableauHeader">
    <xsl:param name="tables" />
    <xsl:param name="curColSize" />
    <xsl:param name="sizeDelta" />
    <xsl:param name="numTables" />

    <xsl:if test="$numTables &gt;= 0">
      <td class="tableauColumnTitle">
        <xsl:if test="$tables[@Size=$curColSize]/@Name">
          <xsl:value-of select="$tables[@Size=$curColSize]/@Name" />
        </xsl:if>
        <xsl:if test="not($tables[@Size=$curColSize]/@Name)">
          <xsl:text xml:space="preserve">&#160;</xsl:text>
        </xsl:if>
      </td>

      <xsl:call-template name="RenderTableauHeader">
        <xsl:with-param name="tables"     select="$tables" />
        <xsl:with-param name="curColSize" select="$curColSize * $sizeDelta" />
        <xsl:with-param name="sizeDelta"  select="$sizeDelta" />
        <xsl:with-param name="numTables"  select="$numTables - 1" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  
  <!-- Create a blank row in the table -->
  <xsl:template name="RenderTableauBlankRow">
    <xsl:param name="numCols" />

    <xsl:if test="$numCols &gt; 0">
      <td><xsl:text xml:space="preserve">&#160;</xsl:text></td>
      
      <xsl:call-template name="RenderTableauBlankRow">
        <xsl:with-param name="numCols" select="$numCols - 1" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <!-- Render a row in a DE tableau -->
  <xsl:template name="RenderElimTableRow">
    <xsl:param name="tableSize" />
    <xsl:param name="endColSize" />
    <xsl:param name="curRowNum" />

    <xsl:if test="$curRowNum &lt; $tableSize * 2">
      <tr>
        <xsl:call-template name="RenderRowCells">
          <xsl:with-param name="startColSize" select="$tableSize" />
          <xsl:with-param name="endColSize"   select="$endColSize" />
          <xsl:with-param name="curRowNum"    select="$curRowNum" />
          <xsl:with-param name="curColSize"   select="$tableSize" />
          <xsl:with-param name="curColPower"  select="1" />
        </xsl:call-template>
      </tr>

      <xsl:call-template name="RenderElimTableRow">
        <xsl:with-param name="tableSize"   select="$tableSize" />
        <xsl:with-param name="endColSize"  select="$endColSize" />
        <xsl:with-param name="curRowNum"   select="$curRowNum + 1" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
   
  <xsl:template name="RenderRowCells">
    <xsl:param name="startColSize" />
    <xsl:param name="endColSize" />
    <xsl:param name="curRowNum" />
    <xsl:param name="curColSize" />
    <xsl:param name="curColPower" />

    <xsl:if test="$curColSize &gt;= $endColSize">
      <td>
        <xsl:variable name="boutIndex"   select="floor($curRowNum div ($curColPower * 4)) + 1" />
        <xsl:variable name="bout"        select="ft:Table[@Size=$curColSize]/ft:Bout[$boutIndex]" />
        <xsl:variable name="prevBoutTop" select="ft:Table[@Size=($curColSize*2)]/ft:Bout[($boutIndex*2)-1]" />
        <xsl:variable name="prevBoutBot" select="ft:Table[@Size=($curColSize*2)]/ft:Bout[$boutIndex*2]" />

        <xsl:choose>
          <!-- ============== Top name cell ============== -->
          <xsl:when test="($curRowNum - ($curColPower - 1)) mod ($curColPower * 4) = 0">
            <xsl:attribute name="class">tableauNameCell tableauBorderBottom</xsl:attribute>
            <xsl:choose>
              <!-- If a name is present, print it -->
              <xsl:when test="$bout/ft:TopCompetitor">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed" select="$bout/@TopSeed" />
                  <xsl:with-param name="name" select="$bout/ft:TopCompetitor/@Name" />
                </xsl:call-template>
              </xsl:when>
              
              <!-- If a bye is present, print it -->
              <xsl:when test="$bout/@TopBye = 'True'">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed" select="$bout/@TopSeed" />
                  <xsl:with-param name="bye"  select="'True'" />
                </xsl:call-template>
              </xsl:when>
              
              <!-- Draw winner name when in rightmost column -->
              <xsl:when test="$curColSize = $endColSize and $prevBoutTop/ft:Winner/@Name != ''">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed" select="$prevBoutTop/@WinnerSeed" />
                  <xsl:with-param name="name" select="$prevBoutTop/ft:Winner/@Name" />
                  <xsl:with-param name="bye"  select="$prevBoutTop/@WinnerBye" />
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>

            <!-- Blank to force cell to draw if empty -->
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </xsl:when>

          <!-- ============== Top score cell ============== -->
          <xsl:when test="($curRowNum - $curColPower) mod ($curColPower * 4) = 0">
            <!-- No right border in last column -->
            <xsl:if test="$curColSize != $endColSize">
              <xsl:attribute name="class">tableauBorderRight</xsl:attribute>
            </xsl:if>
            
            <xsl:choose>
              <!-- Draw score if not first table -->
              <xsl:when test="$curColSize != $startColSize">
                <xsl:call-template name="RenderScoreRefCell">
                  <xsl:with-param name="score"       select="$prevBoutTop/@Score" />
                  <xsl:with-param name="referee"     select="$prevBoutTop/ft:Referee" />
                  <xsl:with-param name="teamMatchID" select="$prevBoutTop/ft:TeamMatch/@ID" />
                  <xsl:with-param name="wdx"         select="$prevBoutTop/@AnyWDX" />
                </xsl:call-template>
              </xsl:when>

              <!-- Draw affiliations in first table -->
              <xsl:when test="$curColSize = $startColSize">
                <span class="tableauCompAffil">
                  <xsl:call-template name="BuildAffiliations">
                    <xsl:with-param name="clubAbbr"    select="$bout/ft:TopCompetitor/@Club" />
                    <xsl:with-param name="divAbbr"     select="$bout/ft:TopCompetitor/@Division" />
                    <xsl:with-param name="countryAbbr" select="$bout/ft:TopCompetitor/@Country" />
                  </xsl:call-template>
                </span>
              </xsl:when>
            </xsl:choose>
            
            <!-- Blank to force cell to draw if empty -->
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </xsl:when>

          <!-- ============== Vertical connector cell ============== -->
          <xsl:when test="($curRowNum - ($curColPower - 1)) mod ($curColPower * 4) &lt; ($curColPower * 2) and
                          ($curRowNum &gt; $curColPower)">
            <!-- No verticals in last column -->
            <xsl:if test="$curColSize != $endColSize">
              <xsl:attribute name="class">tableauBorderRight</xsl:attribute>
            </xsl:if>

            <!-- Blank to force cell to draw -->
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </xsl:when>

          <!-- ============== Bottom name cell ============== -->
          <xsl:when test="($curRowNum - ($curColPower - 1 + ($curColPower * 2))) mod ($curColPower * 4) = 0">
            <!-- No verticals in last column -->
            <xsl:if test="$curColSize != $endColSize">
              <xsl:attribute name="class">tableauNameCell tableauBorderBottomRight</xsl:attribute>
            </xsl:if>
            <xsl:if test="$curColSize = $endColSize">
              <xsl:attribute name="class">tableauNameCell tableauBorderBottom</xsl:attribute>
            </xsl:if>

            <xsl:choose>
              <!-- If a name is present, print it -->
              <xsl:when test="$bout/ft:BottomCompetitor">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed" select="$bout/@BottomSeed" />
                  <xsl:with-param name="name" select="$bout/ft:BottomCompetitor/@Name" />
                </xsl:call-template>
              </xsl:when>
            
              <!-- If a bye is present, print it -->
              <xsl:when test="$bout/@BottomBye = 'True'">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed" select="$bout/@BottomSeed" />
                  <xsl:with-param name="bye"  select="'True'" />
                </xsl:call-template>
              </xsl:when>

              <!-- Draw winner name when in rightmost column -->
              <xsl:when test="$curColSize = $endColSize and $prevBoutBot/ft:Winner/@Name != ''">
                <xsl:call-template name="RenderNameCell">
                  <xsl:with-param name="seed"        select="$prevBoutBot/@WinnerSeed" />
                  <xsl:with-param name="name"        select="$prevBoutBot/ft:Winner/@Name" />
                  <xsl:with-param name="bye"         select="$prevBoutBot/@WinnerBye" />
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>

            <!-- Blank to force cell to draw if empty -->
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </xsl:when>

          <!-- ============== Bottom score cell ============== -->
          <xsl:when test="($curRowNum - ($curColPower + ($curColPower * 2))) mod ($curColPower * 4) = 0">
            <xsl:choose>
              <!-- Draw score if not first table -->
              <xsl:when test="$curColSize != $startColSize">
                <xsl:call-template name="RenderScoreRefCell">
                  <xsl:with-param name="score"       select="$prevBoutBot/@Score" />
                  <xsl:with-param name="referee"     select="$prevBoutBot/ft:Referee" />
                  <xsl:with-param name="teamMatchID" select="$prevBoutBot/ft:TeamMatch/@ID" />
                  <xsl:with-param name="wdx"         select="$prevBoutBot/@AnyWDX" />
                </xsl:call-template>
              </xsl:when>

              <!-- Draw affiliations in first table -->
              <xsl:when test="$curColSize = $startColSize">
                <xsl:if test="$bout/@BottomBye = 'False'">
                  <span class="tableauCompAffil">
                    <xsl:call-template name="BuildAffiliations">
                      <xsl:with-param name="clubAbbr"    select="$bout/ft:BottomCompetitor/@Club" />
                      <xsl:with-param name="divAbbr"     select="$bout/ft:BottomCompetitor/@Division" />
                      <xsl:with-param name="countryAbbr" select="$bout/ft:BottomCompetitor/@Country" />
                    </xsl:call-template>
                  </span>
                </xsl:if>
              </xsl:when>
            </xsl:choose>

            <!-- Blank to force cell to draw if empty -->
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </xsl:when>
        </xsl:choose>
      </td>

      <xsl:call-template name="RenderRowCells">
        <xsl:with-param name="startColSize" select="$startColSize" />
        <xsl:with-param name="endColSize"   select="$endColSize" />
        <xsl:with-param name="curRowNum"    select="$curRowNum" />
        <xsl:with-param name="curColSize"   select="$curColSize div 2" />
        <xsl:with-param name="curColPower"  select="$curColPower * 2" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
    
  
  <xsl:template name="RenderNameCell">
    <xsl:param name="seed" />
    <xsl:param name="name" />
    <xsl:param name="bye" />

    <!-- If name or bye present, print seed -->
    <xsl:if test="($name or $bye = 'True') and $seed != ''">
      <span class="tableauSeed">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="$seed" />
        <xsl:text xml:space="preserve">) </xsl:text>
      </span>
    </xsl:if>

    <!-- If a name is present, print it -->
    <xsl:if test="$name">
      <span class="tableauCompName">
        <xsl:value-of select="$name" />
      </span>
    </xsl:if>

    <!-- If a bye is present, print it -->
    <xsl:if test="$bye = 'True'">
      <span class="tableauCompName">-BYE-</span>
    </xsl:if>
  </xsl:template>

  
  <xsl:template name="RenderScoreRefCell">
    <xsl:param name="score" />
    <xsl:param name="referee" />
    <xsl:param name="teamMatchID" />
    <xsl:param name="wdx" />
    
    <xsl:value-of select="$score" />
    
    <xsl:if test="$teamMatchID">
      <br />
      <span class="tableauMatchDetailsLink">
        <a href="#teamMatch{$teamMatchID}">[<xsl:value-of select="$localized/ft:LocText[@id='MatchDetails']" />]</a>
      </span>
    </xsl:if>
    
    <xsl:if test="$referee/@Name != ''">
      <xsl:if test="$score != ''"><br /></xsl:if>
      <span class="tableauReferee">
        <xsl:value-of select="$localized/ft:LocText[@id='Ref']" />:&#160;
        <xsl:value-of select="$referee/@Name" />
      </span>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="CountCols">
    <xsl:param name="startSize" />                
    <xsl:param name="endSize" />
    <xsl:param name="curCount" />
   
    <xsl:if test="$startSize &lt; $endSize">
      <xsl:value-of select="$curCount" />  
    </xsl:if>
    <xsl:if test="$startSize &gt;= $endSize">
      <xsl:call-template name="CountCols">
        <xsl:with-param name="startSize" select="$startSize div 2" />                
        <xsl:with-param name="endSize" select="$endSize" />  
        <xsl:with-param name="curCount" select="$curCount + 1" />
      </xsl:call-template>
    </xsl:if>               
  </xsl:template>

  <xsl:template name="ComputePower">
    <xsl:param name="startSize" />
    <xsl:param name="endSize" />
    <xsl:param name="curPower" />

    <xsl:if test="$startSize = $endSize">
      <xsl:value-of select="$curPower" />
    </xsl:if>
    <xsl:if test="$startSize &gt; $endSize">
      <xsl:call-template name="ComputePower">
        <xsl:with-param name="startSize" select="$startSize div 2" />
        <xsl:with-param name="endSize" select="$endSize" />
        <xsl:with-param name="curPower" select="$curPower * 2" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  
  
  <xsl:template name="BuildAffiliations">
    <xsl:param name="clubAbbr" />
    <xsl:param name="divAbbr" />
    <xsl:param name="countryAbbr" />

    <xsl:if test="$clubAbbr != ''">
      <xsl:value-of select="$clubAbbr" />
    </xsl:if>

    <xsl:if test="$divAbbr != ''">
      <xsl:if test="$clubAbbr != ''">
        <xsl:text xml:space="preserve"> / </xsl:text>
      </xsl:if>
      <xsl:value-of select="$divAbbr" />
    </xsl:if>

    <xsl:if test="$countryAbbr != ''">
      <xsl:if test="$clubAbbr != '' or $divAbbr != ''">
        <xsl:text xml:space="preserve"> / </xsl:text>
      </xsl:if>
      <xsl:value-of select="$countryAbbr" />
    </xsl:if>
  </xsl:template>
  
  
  <!-- Template to render team match scores -->
  <xsl:template name="RenderTeamMatch">
    <div class="teamMatch">
      <a name="teamMatch{@ID}" class="teamMatchName">
        <xsl:value-of select="ft:MatchName" />
      </a>
      
      <xsl:choose>
        <xsl:when test="@Type='DiscreteBout'">
          <table class="dataTable">
            <tr class="dataTableHeaderRow">
              <td class="teamMatchNumCol">#</td>
              <td class="teamMatchNameCol"><xsl:value-of select="ft:TeamNameLeft"/></td>
              <td class="teamMatchScoreCol"><xsl:value-of select="$localized/ft:LocText[@id='Score']" /></td>
              <td class="teamMatchScoreCol"><xsl:value-of select="$localized/ft:LocText[@id='Score']" /></td>
              <td class="teamMatchNameCol"><xsl:value-of select="ft:TeamNameRight"/></td>
              <td class="teamMatchNumCol">#</td>
            </tr>
          
            <xsl:for-each select="ft:Encounters/ft:Encounter">
              <tr>
                <xsl:choose>
                  <xsl:when test="position() mod 2 = 1">
                    <xsl:attribute name="class">dataTableOddRow</xsl:attribute>
                  </xsl:when>
                  <xsl:when test="position() mod 2 = 0">
                    <xsl:attribute name="class">dataTableEvenRow</xsl:attribute>
                  </xsl:when>
                </xsl:choose>
              
                <td class="teamMatchNumCol">
                  <xsl:value-of select="ft:FencerNumLeft"/>
                </td>
                <td class="teamMatchNameCol">
                  <xsl:value-of select="ft:FencerNameLeft"/>
                </td>

                <xsl:if test="../../../@AnyWDX = 'True'">
                  <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                  <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                </xsl:if>
                
                <xsl:if test="../../../@AnyWDX != 'True'">
                  <td class="teamMatchScoreCol">
                    <xsl:value-of select="ft:BoutScoreLeft"/>
                  </td>
                  <td class="teamMatchScoreCol">
                    <xsl:value-of select="ft:BoutScoreRight"/>
                  </td>
                </xsl:if>
                  
                <td class="teamMatchNameCol">
                  <xsl:value-of select="ft:FencerNameRight"/>
                </td>
                <td class="teamMatchNumCol">
                  <xsl:value-of select="ft:FencerNumRight"/>
                </td>
              </tr>
            </xsl:for-each>
            
            <tr class="dataTableHeaderRow">
              <td class="teamMatchNumCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              <td class="teamMatchNameCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              
              <xsl:if test="../@AnyWDX= 'True'">
                <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              </xsl:if>
              
              <xsl:if test="../@AnyWDX != 'True'">
                <td class="teamMatchScoreCol">
                  <xsl:value-of select="ft:FinalScoreLeft" />
                </td>
                <td class="teamMatchScoreCol">
                  <xsl:value-of select="ft:FinalScoreRight" />
                </td>
              </xsl:if>

              <td class="teamMatchNameCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              <td class="teamMatchNumCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
            </tr>
            
          </table>
      
        </xsl:when>
        <xsl:otherwise>
          <table class="dataTable">
            <tr class="dataTableHeaderRow">
              <td class="teamMatchNumCol">#</td>
              <td class="teamMatchNameCol"><xsl:value-of select="ft:TeamNameLeft"/></td>
              <td class="teamMatchTouchesCol"><xsl:value-of select="$localized/ft:LocText[@id='TS']" /></td>
              <td class="teamMatchScoreCol"><xsl:value-of select="$localized/ft:LocText[@id='Score']" /></td>
              <td class="teamMatchScoreCol"><xsl:value-of select="$localized/ft:LocText[@id='Score']" /></td>
              <td class="teamMatchTouchesCol"><xsl:value-of select="$localized/ft:LocText[@id='TS']" /></td>
              <td class="teamMatchNameCol"><xsl:value-of select="ft:TeamNameRight"/></td>
              <td class="teamMatchNumCol">#</td>
            </tr>
          
            <xsl:for-each select="ft:Encounters/ft:Encounter">
              <tr>
                <xsl:choose>
                  <xsl:when test="position() mod 2 = 1">
                    <xsl:attribute name="class">dataTableOddRow</xsl:attribute>
                  </xsl:when>
                  <xsl:when test="position() mod 2 = 0">
                    <xsl:attribute name="class">dataTableEvenRow</xsl:attribute>
                  </xsl:when>
                </xsl:choose>
              
                <td class="teamMatchNumCol">
                  <xsl:value-of select="ft:FencerNumLeft"/>
                </td>
                <td class="teamMatchNameCol">
                  <xsl:value-of select="ft:FencerNameLeft"/>
                </td>

                <xsl:if test="../../../@AnyWDX = 'True'">
                  <td class="teamMatchTouchesCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                  <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                  <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                  <td class="teamMatchTouchesCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                </xsl:if>
                
                <xsl:if test="../../../@AnyWDX != 'True'">
                  <td class="teamMatchTouchesCol">
                    <xsl:value-of select="ft:TouchesLeft"/>
                  </td>
                  <td class="teamMatchScoreCol">
                    <xsl:value-of select="ft:ScoreLeft"/>
                  </td>
                  <td class="teamMatchScoreCol">
                    <xsl:value-of select="ft:ScoreRight"/>
                  </td>
                  <td class="teamMatchTouchesCol">
                    <xsl:value-of select="ft:TouchesRight"/>
                  </td>
                </xsl:if>
                  
                <td class="teamMatchNameCol">
                  <xsl:value-of select="ft:FencerNameRight"/>
                </td>
                <td class="teamMatchNumCol">
                  <xsl:value-of select="ft:FencerNumRight"/>
                </td>
              </tr>
            </xsl:for-each>
            
            <tr class="dataTableHeaderRow">
              <td class="teamMatchNumCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              <td class="teamMatchNameCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              <td class="teamMatchTouchesCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              
              <xsl:if test="../@AnyWDX= 'True'">
                <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              </xsl:if>
              
              <xsl:if test="../@AnyWDX != 'True'">
                <td class="teamMatchScoreCol">
                  <xsl:value-of select="ft:FinalScoreLeft" />
                </td>
                <td class="teamMatchScoreCol">
                  <xsl:value-of select="ft:FinalScoreRight" />
                </td>
              </xsl:if>

              <td class="teamMatchTouchesCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              <td class="teamMatchNameCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              <td class="teamMatchNumCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
            </tr>
          </table>
        </xsl:otherwise>
      </xsl:choose>
      
      <!-- Match referees, if any -->
      <xsl:if test="ft:Referees/ft:Referee">
        <div class="teamMatchRefs">
          <xsl:value-of select="$localized/ft:LocText[@id='Referees']" />
          <br/>
          <xsl:for-each select="ft:Referees/ft:Referee">
            <xsl:value-of select="." /><br/>
          </xsl:for-each>
        </div>
      </xsl:if>
    </div>
  </xsl:template>
</xsl:stylesheet>
