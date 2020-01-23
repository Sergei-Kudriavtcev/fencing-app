<?xml version="1.0" encoding="utf-8"?>
<!-- 
Fencing Time
By Daniel Berke
(C) Copyright by Daniel Berke 
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ft="http://www.fencingtime.com">
  <xsl:output indent="yes" />
  <xsl:variable name="fileVersion">4.3</xsl:variable>

  <!-- Standard parameters -->
  <xsl:param name="localPath"  />
  <xsl:param name="flagPath"   />
  <xsl:param name="fontSize"   />
  <xsl:param name="langCode"   />
  <xsl:param name="bgClass"    />

  <!-- Page-specific parameters -->
  <xsl:param name="showStrips"    />
  <xsl:param name="showRefs"      />
  <xsl:param name="showClubs"     />
  <xsl:param name="showDivs"      />
  <xsl:param name="showCountries" />
  <xsl:param name="showRatings"   />
  <xsl:param name="showTimes"     />
  <xsl:param name="specificPoolNum" />
  <xsl:param name="screenWidth" />
  
  <xsl:variable name="localized" select="document(concat('Lang\', $langCode, '.xml'))/ft:LocalizedText" />
  
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <link rel="stylesheet" type="text/css" href="{$localPath}/Styles/default.css" />
      </head>

      <xsl:variable name="col1pools" select="(count(/ArrayOfPool/Pool) + 1) div 2" />
      
      <body class="{$bgClass}" style="font-size: {$fontSize}em;">
        <div class="page">
          <xsl:if test="$screenWidth &lt; 800">
            <xsl:for-each select="/ArrayOfPool/Pool">
              <xsl:call-template name="RenderPool" />
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="$screenWidth &gt;= 800">
            <div class="twoColumns">
              <div class="leftColumn">
                <xsl:for-each select="/ArrayOfPool/Pool[PoolNum mod 2 = 1]">
                  <xsl:call-template name="RenderPool" />
                </xsl:for-each>
              </div>
              <div class="rightColumn">
                <xsl:for-each select="/ArrayOfPool/Pool[PoolNum mod 2 = 0]">
                  <xsl:call-template name="RenderPool" />
                </xsl:for-each>
              </div>
            </div>
          </xsl:if>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="RenderPool">
    <h3><xsl:value-of select="$localized/ft:LocText[@id='PoolNum']" /><xsl:value-of select="PoolNum" /></h3>
    <xsl:if test="($showStrips = 'true' and StripNum != '') or PoolTime != ''">
      <span class="poolStripTime">
        <xsl:if test="$showStrips = 'true' and StripNum != ''">
          <xsl:value-of select="$localized/ft:LocText[@id='onStrip']" />&#160;
          <xsl:value-of select="StripNum" />&#160;
        </xsl:if>
        <xsl:if test="$showTimes = 'true' and PoolTime != ''">
          <xsl:value-of select="$localized/ft:LocText[@id='atTime']" />&#160;
          <xsl:value-of select="PoolTime" />
        </xsl:if>
      </span>
    </xsl:if>
    
    <table class="dataTable">
      <tr class="headerRow">
        <th><xsl:value-of select="$localized/ft:LocText[@id='Name']" /></th>
        <xsl:if test="$showClubs = 'true'"><th><xsl:value-of select="$localized/ft:LocText[@id='Clubs']" /></th></xsl:if>
        <xsl:if test="$showDivs = 'true'"><th><xsl:value-of select="$localized/ft:LocText[@id='Division']" /></th></xsl:if>
        <xsl:if test="$showCountries = 'true'"><th><xsl:value-of select="$localized/ft:LocText[@id='Country']" /></th></xsl:if>
      </tr>

      <!-- Create a row for each competitor -->
      <xsl:for-each select="Competitors/PoolCompetitor">
        <xsl:variable name="thisComp" select="." />
        
        <tr>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0">poolEvenRow</xsl:when>
              <xsl:otherwise>poolOddRow</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>

          <td class="poolNameCol">
            <xsl:value-of select="Name" />
          </td>

          <xsl:if test="$showClubs = 'true'">
            <td>
              <xsl:value-of select="ClubAbbr" />
            </td>
          </xsl:if>
          <xsl:if test="$showDivs = 'true'">
            <td>
              <xsl:value-of select="DivAbbr" />
            </td>
          </xsl:if>
          <xsl:if test="$showCountries = 'true'">
            <td>
              <xsl:if test="CountryAbbr != ''">
                <img src="{$flagPath}\Flags\{CountryAbbr}.png" />&#160;
                <xsl:value-of select="CountryAbbr" />
              </xsl:if>
            </td>
          </xsl:if>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  
  <xsl:include href="Transform\Common.xslt" />
</xsl:stylesheet>
