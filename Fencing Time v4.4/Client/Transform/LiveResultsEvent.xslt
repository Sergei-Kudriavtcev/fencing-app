<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Fencing Time
By Daniel Berke
(C) Copyright by Daniel Berke 
-->
<!-- Tournament export to html - event page -->
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
  <xsl:template match="ft:EventSnapshot">
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
        <link rel="stylesheet" href="FTFlags.min.css" type="text/css" />
        <xsl:if test="$usfa">
          <link rel="stylesheet" href="FTStylesUSFA.min.css" type="text/css" />
        </xsl:if>
        <link rel="stylesheet" href="jquery-ui-1.8.16.custom.min.css" type="text/css" />
        
        <script src="jquery-1.6.2.min.js" type="text/javascript"><xsl:text> </xsl:text></script> 
        <script src="jquery-ui-1.8.16.custom.min.js" type="text/javascript"><xsl:text> </xsl:text></script> 
        <script src="ft.min.js" type="text/javascript"><xsl:text> </xsl:text></script> 
        
        <xsl:value-of select="$customHead" disable-output-escaping="yes" />
      </head>

      <body>
        <div class="page">
          <!-- Page title -->
          <div class="pageHeader ui-corner-all">
            <xsl:if test="ft:EventInfo/@mask">
              <xsl:if test="$navButtons">
                <xsl:attribute name="style">height: 160px; background-color: #0E1130;</xsl:attribute>
              </xsl:if>
            </xsl:if>
            <div class="leftLogo">
              <div>
                <a href="index.htm">
                  <xsl:if test="ft:EventInfo/@mask">
                    <img src="ftmlogo.png" />
                  </xsl:if>
                  <xsl:if test="not(ft:EventInfo/@mask)">
                    <img src="ftlogo.png" />
                  </xsl:if>  
                </a>
              </div>
              <xsl:if test="not(ft:EventInfo/@mask)">
                <div class="ftLogoText">www.FencingTime.com</div>
              </xsl:if>  
              <xsl:if test="$navButtons">
                <div class="backButton navButton ui-corner-all">
                  <a href="index.htm"><xsl:value-of select="$localized/ft:LocText[@id='ReturnToSched']" /></a>
                </div>
              </xsl:if>
            </div>

            <div class="tournInfo">
              <span class="tournName">
                <xsl:value-of select="ft:EventInfo/@TournamentName" />
              </span>
              <br />
              <span class="tournDetails">
                <xsl:value-of select="ft:EventInfo/@Name" /><br />
                <xsl:value-of select="ft:EventInfo/@Date" />
                <xsl:text xml:space="preserve"> - </xsl:text>
                <xsl:value-of select="ft:EventInfo/@Time" />
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
          

          <div id="roundTabs" class="roundTabsDiv">
            <!-- Section links -->
            <ul class="jumpList">
              <xsl:if test="ft:EventFormat">
                <li><a href="#eventFormat" class="jumpListItem1"><xsl:value-of select="$localized/ft:LocText[@id='EventFormat']" /></a></li>
              </xsl:if>

              <xsl:if test="ft:PreliminarySeeding">
                <li><a href="#prelimSeed" class="jumpListItem1"><xsl:value-of select="$localized/ft:LocText[@id='PrelimSeeding']" /></a></li>
              </xsl:if>

              <xsl:if test="ft:FencersByCountry">
                <li><a href="#fenByCountry" class="jumpListItem1"><xsl:value-of select="$localized/ft:LocText[@id='EventFencers']" /></a></li>
              </xsl:if>
              
              <xsl:if test="ft:CompetitorList">
                <li><a href="#checkIn" class="jumpListItem1"><xsl:value-of select="$localized/ft:LocText[@id='CheckInStatus']" /></a></li>
              </xsl:if>
             
              <xsl:if test="ft:RoundList">
                <xsl:for-each select="ft:RoundList/ft:Round">
                  <li>
                    <a href="#Round{@Number}" class="jumpListItem1"><xsl:value-of select="@Name"/></a>
                  </li>
                </xsl:for-each>
              </xsl:if>

              <xsl:if test="ft:ResultsSoFar">
                <li><a href="#resultsSoFar" class="jumpListItem1"><xsl:value-of select="$localized/ft:LocText[@id='ResultsSoFar']" /></a></li>
              </xsl:if>
              
              <xsl:if test="ft:FinalResults">
                <li><a href="#finalResults" class="jumpListItem1"><xsl:value-of select="$localized/ft:LocText[@id='FinalResults']" /></a></li>
              </xsl:if>
            </ul>

            <!-- Event format report -->
            <xsl:if test="ft:EventFormat">
              <div class="roundDiv" id="eventFormat">
                <div class="roundName"><xsl:value-of select="$localized/ft:LocText[@id='EventFormat']" /></div>
                <xsl:call-template name="RenderRoundFormat">
                  <xsl:with-param name="format" select="ft:EventFormat" />
                  <xsl:with-param name="evType" select="ft:EventInfo/@Type" />
                </xsl:call-template>
              </div>
            </xsl:if>
            
            <!-- Preliminary seeding -->
            <xsl:if test="ft:PreliminarySeeding">
              <div class="roundDiv" id="prelimSeed">
                <div class="roundName"><xsl:value-of select="$localized/ft:LocText[@id='PrelimSeeding']" /></div>
                <xsl:call-template name="RenderSeeding">
                  <xsl:with-param name="seeding"  select="ft:PreliminarySeeding" />
                  <xsl:with-param name="roundNum" select="0" />
                  <xsl:with-param name="evType"   select="ft:EventInfo/@Type" />
                </xsl:call-template>
                
                <xsl:call-template name="NCAANotice" />
              </div>
            </xsl:if>

            <!-- Check-in list -->
            <xsl:if test="ft:CompetitorList">
              <div class="roundDiv" id="checkIn">
                <div class="roundName"><xsl:value-of select="$localized/ft:LocText[@id='CompCheckInStatus']" /></div>
                <xsl:call-template name="RenderCheckIn">
                  <xsl:with-param name="comps"  select="ft:CompetitorList" />
                  <xsl:with-param name="evType" select="ft:EventInfo/@Type" />
                </xsl:call-template>
                
                <xsl:call-template name="NCAANotice" />
              </div>
            </xsl:if>

            <!-- Fencers by country -->
            <xsl:if test="ft:FencersByCountry">
              <div class="roundDiv" id="fenByCountry">
                <div class="roundName"><xsl:value-of select="$localized/ft:LocText[@id='EventFencers']" /></div>
                <xsl:call-template name="RenderFencersByCountry">
                  <xsl:with-param name="fencers" select="ft:FencersByCountry" />
                </xsl:call-template>
              </div>
            </xsl:if>
            
            <!-- Round data -->
            <xsl:if test="ft:RoundList">
              <xsl:for-each select="ft:RoundList/ft:Round">
                <div class="roundDiv" id="Round{@Number}">
                  <div id="round{@Number}ItemTabs" class="roundItemTabsDiv">
                    <div class="roundName">
                      <xsl:value-of select="@Name"/>
                    </div>

                    <ul class="jumpList">
                      <xsl:if test="ft:Seeding">
                        <li><a href="#Round{@Number}Seeding" class="jumpListItem2"><xsl:value-of select="$localized/ft:LocText[@id='Seeding']" /></a></li>
                      </xsl:if>
                      <xsl:if test="ft:StripAssignments">
                        <li><a href="#Round{@Number}StripsName" class="jumpListItem2"><xsl:value-of select="$localized/ft:LocText[@id='StripsByName']" /></a></li>
                        <xsl:if test="ft:StripAssignments/*/@Club">
                          <li><a href="#Round{@Number}StripsClub" class="jumpListItem2"><xsl:value-of select="$localized/ft:LocText[@id='StripsByClub']" /></a></li>
                        </xsl:if>
                      </xsl:if>
                      <xsl:if test="ft:Scores">
                        <li><a href="#Round{@Number}Scores" class="jumpListItem2">
                          <xsl:choose>
                            <xsl:when test="@Type = 'Pool'"><xsl:value-of select="$localized/ft:LocText[@id='Pools']" /></xsl:when>
                            <xsl:when test="@Type = 'Elimination'"><xsl:value-of select="$localized/ft:LocText[@id='Tableau']" /></xsl:when>
                            <xsl:otherwise><xsl:value-of select="$localized/ft:LocText[@id='Scores']" /></xsl:otherwise>
                          </xsl:choose>
                        </a></li>
                      </xsl:if>
                      <xsl:if test="ft:TempPoolResults">
                        <li><a href="#Round{@Number}TPR" class="jumpListItem2"><xsl:value-of select="$localized/ft:LocText[@id='TemporaryPoolResults']" /></a></li>
                      </xsl:if>
                    </ul>
                    
                    <!-- Round seeding -->
                    <xsl:if test="ft:Seeding">
                      <div class="roundItemDiv" id="Round{@Number}Seeding">
                        <div class="roundItemName"><xsl:value-of select="$localized/ft:LocText[@id='RoundSeeding']" /></div>
                        <xsl:call-template name="RenderSeeding">
                          <xsl:with-param name="seeding"  select="ft:Seeding" />
                          <xsl:with-param name="roundNum" select="@Number" />
                          <xsl:with-param name="evType"   select="../../ft:EventInfo/@Type" />
                        </xsl:call-template>
                      </div>
                    </xsl:if>

                    <!-- Strip assignments -->
                    <xsl:if test="ft:StripAssignments">
                      <div class="roundItemDiv" id="Round{@Number}StripsName">
                        <div class="roundItemName"><xsl:value-of select="$localized/ft:LocText[@id='StripsByName']" /></div>
                        <xsl:call-template name="RenderStripAssignmentsByName">
                          <xsl:with-param name="comps" select="ft:StripAssignments" />
                        </xsl:call-template>
                      </div>
                      <xsl:if test="ft:StripAssignments/*/@Club">
                        <div class="roundItemDiv" id="Round{@Number}StripsClub">
                          <div class="roundItemName"><xsl:value-of select="$localized/ft:LocText[@id='StripsByClub']" /></div>
                          <xsl:call-template name="RenderStripAssignmentsByClub">
                            <xsl:with-param name="comps" select="ft:StripAssignments" />
                          </xsl:call-template>
                        </div>
                      </xsl:if>
                    </xsl:if>
                    
                    <!-- Round scores-->
                    <xsl:if test="ft:Scores">
                      <div class="roundItemDiv" id="Round{@Number}Scores">
                        <div class="roundItemName"><xsl:value-of select="$localized/ft:LocText[@id='RoundScores']" /></div>
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
                    </xsl:if>

                    <!-- Temp pool results -->
                    <xsl:if test="ft:TempPoolResults">
                      <div class="roundItemDiv" id="Round{@Number}TPR">
                        <div class="roundItemName"><xsl:value-of select="$localized/ft:LocText[@id='TemporaryPoolResults']" /></div>
                        <xsl:call-template name="RenderTempPoolResults">
                          <xsl:with-param name="results" select="ft:TempPoolResults" />
                        </xsl:call-template>
                      </div>
                    </xsl:if>
                  </div>
                  
                  <xsl:call-template name="NCAANotice" />
                </div>
              </xsl:for-each>
            </xsl:if>

            <!-- Results so far -->
            <xsl:if test="ft:ResultsSoFar">
              <div class="roundDiv" id="resultsSoFar">
                <div class="roundName"><xsl:value-of select="$localized/ft:LocText[@id='ResultsSoFar']" /></div>
                <xsl:call-template name="RenderResults">
                  <xsl:with-param name="results" select="ft:ResultsSoFar" />
                  <xsl:with-param name="evType"  select="ft:EventInfo/@Type" />
                </xsl:call-template>

                <xsl:call-template name="NCAANotice" />
              </div>
            </xsl:if>

            <!-- Final results -->
            <xsl:if test="ft:FinalResults">
              <div class="roundDiv" id="finalResults">
                <div class="roundName"><xsl:value-of select="$localized/ft:LocText[@id='FinalResults']" /></div>

                <div class="finalResultsEventClass">
                  <xsl:value-of select="$localized/ft:LocText[@id='FinishTime']" />&#160;<xsl:value-of select="ft:FinalResults/@FinishTime" />
                </div>
                
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

                <xsl:call-template name="NCAANotice" />
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

      <span class="flag flag{$countryAbbr}"><xsl:comment> </xsl:comment></span>
      <xsl:value-of select="$countryAbbr" />
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="NCAANotice">
    <xsl:if test="/ft:EventSnapshot/ft:EventInfo[@Authority = 'USFA']"> 
      <div class="ncaa">
        The status of National Collegiate Athletic Association Student Athletes competing in USFA tournaments during the academic year is unaffected by listing their school affiliation or as being "Unattached".  The information presented here is used solely to comply with fencing rule o.13 so that conflicts are avoided.
      </div>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="RenderRoundFormat">
    <xsl:param name="format" />
    <xsl:param name="evType" />
    
    <div class="eventFormat">
      <xsl:if test="$evType='Team'">
        <xsl:value-of select="$localized/ft:LocText[@id='NumTeams']" />&#160;<xsl:value-of select="$format/@NumFencers" />
      </xsl:if>
      <xsl:if test="$evType='Individual'">
        <xsl:value-of select="$localized/ft:LocText[@id='NumFencers']" />&#160;<xsl:value-of select="$format/@NumFencers" />
      </xsl:if>
    </div>
    
    <xsl:for-each select="$format/ft:Round">
      <xsl:sort select="@Num" />
        
      <div class="eventFormatRound">
        <span class="eventFormat eventFormatRoundName"><xsl:value-of select="$localized/ft:LocText[@id='RoundNum']" /><xsl:value-of select="@Num" /></span>
        <br/>
        <span class="eventFormatDetails">
          <xsl:for-each select="ft:Format">
            <xsl:value-of select="." />
            <br/>
          </xsl:for-each>
        </span>
      </div>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:include href="LiveResultsTables.xslt" />
  <xsl:include href="LiveResultsPools.xslt" />
  <xsl:include href="LiveResultsDEs.xslt" />
</xsl:stylesheet>
