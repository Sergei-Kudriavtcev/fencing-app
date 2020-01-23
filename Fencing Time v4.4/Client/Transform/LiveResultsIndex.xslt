<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Fencing Time
By Daniel Berke
(C) Copyright by Daniel Berke 
-->
<!-- Tournament export to html - index page -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ft="http://www.fencingtime.com">
  <xsl:output indent="yes" encoding="UTF-8" omit-xml-declaration="yes" method="html" />
  <xsl:variable name="fileVersion">4.4</xsl:variable>

  <xsl:param name="createTime" />
  <xsl:param name="usfa"       />
  <xsl:param name="navButtons" />
  <xsl:param name="logoFile"   />
  <xsl:param name="langCode"   />
  <xsl:param name="langFile"   />
  <xsl:param name="customHead" />
  
  <xsl:variable name="localized" select="document($langFile)/ft:LocalizedText" />
  
  <!-- Main template matching rule -->
  <xsl:template match="/ft:TournamentIndex">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"&gt;</xsl:text>  
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta http-equiv="Content-Language" content="{$langCode}" />
        <meta http-equiv="Cache-Control" content="private, max-age=30" />

        <title>
          <xsl:value-of select="ft:TournamentInfo/@Name" />&#160;<xsl:value-of select="$localized/ft:LocText[@id='LiveResults']" />
        </title>

        <link rel="stylesheet" href="FTStyles.min.css" type="text/css" />
        <xsl:if test="$usfa">
          <link rel="stylesheet" href="FTStylesUSFA.min.css" type="text/css" />
        </xsl:if>
        <link rel="stylesheet" href="jquery-ui-1.8.16.custom.min.css" type="text/css" />
        
        <script src="jquery-1.6.2.min.js" type="text/javascript"><xsl:text> </xsl:text></script> 
        <script src="jquery-ui-1.8.16.custom.min.js" type="text/javascript"><xsl:text> </xsl:text></script> 
        
        <script type="text/javascript">
          $(document).ready(function() 
          {
            $("#scheduleTab").tabs();
          });
        </script>

        <xsl:value-of select="$customHead" disable-output-escaping="yes" />
      </head>

      <body>
        <div class="page">
          <!-- Page title -->
          <div class="pageHeader ui-corner-all">
            <xsl:if test="ft:TournamentInfo/@mask">
              <xsl:attribute name="style">background-color: #0E1130;</xsl:attribute>
            </xsl:if>
            <div class="leftLogo">
              <div>
                <xsl:if test="ft:TournamentInfo/@mask">
                  <img src="ftmlogo.png" />
                </xsl:if>
                <xsl:if test="not(ft:TournamentInfo/@mask)">
                  <img src="ftlogo.png" />
                </xsl:if>  
              </div>
              <xsl:if test="not(ft:TournamentInfo/@mask)">
                <div class="ftLogoText">www.FencingTime.com</div>
              </xsl:if>  
              <xsl:if test="$navButtons and $usfa">
                <div class="backButton navButton ui-corner-all">
                  <a href="#" target="_blank">Mobile Version</a>
                </div>
              </xsl:if>
            </div>

            <div class="tournInfo">
              <span class="tournName">
                <xsl:value-of select="ft:TournamentInfo/@Name" />
              </span>
              <br />
              <span class="tournDetails">
                <xsl:value-of select="ft:TournamentInfo/@Location" /><br />
                <xsl:value-of select="ft:TournamentInfo/@StartDate" />
                <xsl:if test="ft:TournamentInfo/@StartDate != ft:TournamentInfo/@EndDate">
                  <xsl:text xml:space="preserve"> - </xsl:text>
                  <xsl:value-of select="ft:TournamentInfo/@EndDate" />
                </xsl:if>
              </span>
              <br />
              <br />
              <span class="lastUpdate">
                  <xsl:value-of select="$localized/ft:LocText[@id='LastUpdated']" />:&#160;&#160;&#160;
                  <xsl:value-of select="$createTime" />
              </span>
            </div>

            <xsl:if test="$logoFile">
              <div class="rightLogo">
                <img src="{$logoFile}" />
              </div>
            </xsl:if>
          </div>
      
          <div id="scheduleTab" class="scheduleTabDiv">
            <ul class="jumpList">
              <li><a href="#schedule" class="jumpListItem1"><xsl:value-of select="$localized/ft:LocText[@id='EventSchedule']" /></a></li>
              <xsl:if test="ft:MedalCounts">
                <li><a href="#medals" class="jumpListItem1"><xsl:value-of select="$localized/ft:LocText[@id='Medals']" /></a></li>
              </xsl:if>
            </ul>
            
            <div id="schedule">
              <xsl:for-each select="ft:Schedule/ft:Day">
                <div class="scheduleDayName">
                  <xsl:value-of select="@Date" />
                </div>
                <table class="dataTable">
                  <!-- Table header row -->
                  <tr class="dataTableHeaderRow">
                    <th style="width:15%;"><xsl:value-of select="$localized/ft:LocText[@id='Time']" /></th>
                    <th style="width:50%;"><xsl:value-of select="$localized/ft:LocText[@id='Event']" /></th>
                    <th><xsl:value-of select="$localized/ft:LocText[@id='Details']" /></th>
                  </tr>

                  <!-- Event rows -->
                  <xsl:for-each select="ft:Event">
                    <tr>
                      <xsl:choose>
                        <xsl:when test="position() mod 2 = 1">
                          <xsl:attribute name="class">dataTableOddRow</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="position() mod 2 = 0">
                          <xsl:attribute name="class">dataTableEvenRow</xsl:attribute>
                        </xsl:when>
                      </xsl:choose>

                      <td>
                        <xsl:value-of select="@Time" />
                      </td>
                      <td>
                        <a href="{@Filename}.htm"><xsl:value-of select="@Name" /></a>
                      </td>
                      <td>
                        <a href="{@Filename}.htm"><xsl:value-of select="$localized/ft:LocText[@id='View']" /></a>
                      </td>
                    </tr>
                </xsl:for-each>
              </table>
              <br />
              </xsl:for-each>
            
              <xsl:if test="$usfa and ft:TournamentInfo/@Authority='USFA'">
                <div class="finalResultsRatingsNote">
                  Event postings in the venue reflect the official event results.  Results displayed on this site are not considered official until validated by the National Office.
                </div>
              </xsl:if>
            </div>
            
            <!-- Event format report -->
            <xsl:if test="ft:MedalCounts">
              <div class="scheduleTab" id="medals">
                <div class="scheduleDayName">
                  <xsl:value-of select="$localized/ft:LocText[@id='MedalCounts']" />
                </div>
                <table class="dataTable" style="width:50%;">
                  <!-- Table header row -->
                  <tr class="dataTableHeaderRow">
                    <th><xsl:value-of select="$localized/ft:LocText[@id='Place']" /></th>
                    <th><xsl:value-of select="$localized/ft:LocText[@id='Country']" /></th>
                    <th><xsl:value-of select="$localized/ft:LocText[@id='Gold']" /></th>
                    <th><xsl:value-of select="$localized/ft:LocText[@id='Silver']" /></th>
                    <th><xsl:value-of select="$localized/ft:LocText[@id='Bronze']" /></th>
                    <th><xsl:value-of select="$localized/ft:LocText[@id='Total']" /></th>
                  </tr>

                  <!-- Country rows -->
                  <xsl:for-each select="ft:MedalCounts/ft:MedalCount">
                    <tr>
                      <xsl:choose>
                        <xsl:when test="position() mod 2 = 1">
                          <xsl:attribute name="class">dataTableOddRow</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="position() mod 2 = 0">
                          <xsl:attribute name="class">dataTableEvenRow</xsl:attribute>
                        </xsl:when>
                      </xsl:choose>

                      <td>
                        <xsl:value-of select="@Place" />
                        <xsl:text xml:space="preserve">&#160;</xsl:text>
                      </td>
                      <td>
                        <span class="flag flag{@Country}"><xsl:comment> </xsl:comment></span>
                        <xsl:value-of select="@Country" />
                        <xsl:text xml:space="preserve">&#160;</xsl:text>
                      </td>
                      <td>
                        <xsl:if test="@Gold != 0">
                          <xsl:value-of select="@Gold" />
                        </xsl:if>
                        <xsl:text xml:space="preserve">&#160;</xsl:text>
                      </td>
                      <td>
                        <xsl:if test="@Silver != 0">
                          <xsl:value-of select="@Silver" />
                        </xsl:if>
                        <xsl:text xml:space="preserve">&#160;</xsl:text>
                      </td>
                      <td>
                        <xsl:if test="@Bronze != 0">
                          <xsl:value-of select="@Bronze" />
                        </xsl:if>
                        <xsl:text xml:space="preserve">&#160;</xsl:text>
                      </td>
                      <td>
                        <xsl:value-of select="@Total" />
                        <xsl:text xml:space="preserve">&#160;</xsl:text>
                      </td>
                    </tr>
                  </xsl:for-each>
                </table>
              </div>
            </xsl:if>
          </div>
         
          <div class="pageFooter">
            <xsl:value-of select="$localized/ft:LocText[@id='LRGenerated']" />&#160;Fencing Time v<xsl:value-of select="@ftversion" />&#160;<xsl:value-of select="$localized/ft:LocText[@id='TournSW']" /><br/> 
            <a href="http://www.fencingtime.com">www.FencingTime.com</a><br/>
            Copyright © 2018 by Fencing Time, LLC
          </div>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
