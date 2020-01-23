<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Fencing Time
By Daniel Berke
(C) Copyright by Daniel Berke 
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ft="http://www.fencingtime.com">
  <xsl:variable name="fileVersion3">4.4</xsl:variable>

  <!-- Template to render pool scores-->
  <xsl:template name="RenderPool">
  
    <div class="poolNum">
      <xsl:value-of select="$localized/ft:LocText[@id='PoolNum']" /><xsl:value-of select="@Number" />
    </div>
    <xsl:if test="@Strip != '' or @Time != ''">
      <span class="poolStripTime">
        <xsl:if test="@Strip != ''">
          <xsl:value-of select="$localized/ft:LocText[@id='OnStrip']" />&#160;<xsl:value-of select="@Strip" />
        </xsl:if>
        <xsl:if test="@Time != ''">
          &#160;<xsl:value-of select="$localized/ft:LocText[@id='At']" />&#160;<xsl:value-of select="@Time" />
        </xsl:if>
      </span>
    </xsl:if>
  
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
                <xsl:with-param name="clubAbbr"     select="@Club" />
                <xsl:with-param name="divAbbr"      select="@Division" />
                <xsl:with-param name="countryAbbr"  select="@Country" />
              </xsl:call-template>
            </span>
            <br/>
          </xsl:if>
        </xsl:for-each>
      </div>
    </xsl:if>
    
    <!-- Team matches, if any -->
    <xsl:if test="ft:TeamMatches/ft:TeamMatch">
      <div class="poolTeamMatchDiv">
        <xsl:for-each select="ft:TeamMatches/ft:TeamMatch">
          <p>
            <xsl:call-template name="RenderTeamMatch">
              <xsl:with-param name="isPool" select="'True'" />
            </xsl:call-template>
          </p>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
