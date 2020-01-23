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

  <xsl:variable name="localized" select="document(concat('Lang\', $langCode, '.xml'))/ft:LocalizedText" />
  
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <link rel="stylesheet" type="text/css" href="{$localPath}/Styles/default.css" />
      </head>

      <body class="{$bgClass}" style="font-size: {$fontSize}em;">
        <div class="page">
          <h2><xsl:value-of select="$localized/ft:LocText[@id='EF_EventFormat']" /></h2>
          
          <div class="formatNumComps">
            <xsl:call-template name="FormatString">
              <xsl:with-param name="localized" select="$localized" />
              <xsl:with-param name="id"        select="'EF_NumComps'" />
              <xsl:with-param name="arg1"      select="/EventFormat/NumCompetitors" />
            </xsl:call-template>
          </div>

          <xsl:for-each select="/EventFormat/RoundFormats/RoundFormat">
            <div class="roundFormat">
              <!-- Round number header -->
              <div class="roundNum">
                <xsl:value-of select="$localized/ft:LocText[@id='EF_RoundNum']" />
                <xsl:value-of select="RoundNum" />:
                <xsl:choose>
                  <xsl:when test="RoundType = 'Pool'">
                    <xsl:value-of select="$localized/ft:LocText[@id='RT_Pool']" />
                  </xsl:when>
                  <xsl:when test="RoundType = 'Elim'">
                    <xsl:value-of select="$localized/ft:LocText[@id='RT_SingleElim']" />
                  </xsl:when>
                  <xsl:when test="RoundType = 'Rep32'">
                    <xsl:value-of select="$localized/ft:LocText[@id='RT_Rep32']" />
                  </xsl:when>
                  <xsl:when test="RoundType = 'Rep16'">
                    <xsl:value-of select="$localized/ft:LocText[@id='RT_Rep16']" />
                  </xsl:when>
                  <xsl:when test="RoundType = 'APF16'">
                    <xsl:value-of select="$localized/ft:LocText[@id='RT_APF16']" />
                  </xsl:when>
                  <xsl:when test="RoundType = 'APF8'">
                    <xsl:value-of select="$localized/ft:LocText[@id='RT_APF8']" />
                  </xsl:when>
                </xsl:choose>
              </div>

              <!-- Round details -->
              <div class="formatText">
                <!-- Randomization in pairs, if any -->
                <xsl:if test="RandomizePairsStartSeed &gt; 0 and RandomizePairsEndSeed &gt; 0">
                  <xsl:if test="RandomizePairsStartSeed != 1">
                    <xsl:call-template name="FormatString">
                      <xsl:with-param name="localized" select="$localized" />
                      <xsl:with-param name="id"        select="'EF_SeedsFixed'" />
                      <xsl:with-param name="arg1"      select="RandomizePairsStartSeed - 1" />
                    </xsl:call-template>
                    <br/>
                  </xsl:if>
                  <xsl:call-template name="FormatString">
                    <xsl:with-param name="localized" select="$localized" />
                    <xsl:with-param name="id"        select="'EF_SeedsRandInPairs'" />
                    <xsl:with-param name="arg1"      select="RandomizePairsStartSeed" />
                    <xsl:with-param name="arg2"      select="RandomizePairsEndSeed" />
                  </xsl:call-template>
                  <br/>
                </xsl:if>

                <!-- Byes past the round, if any -->
                <xsl:if test="NumByes != 0">
                  <xsl:call-template name="FormatString">
                    <xsl:with-param name="localized" select="$localized" />
                    <xsl:with-param name="id"        select="'EF_TopExempt'" />
                    <xsl:with-param name="arg1"      select="NumByes" />
                  </xsl:call-template>
                  <br/>
                </xsl:if>

                <!-- Pool round info -->
                <xsl:if test="PoolRoundFormat">
                  <!-- Number and sizes of pools -->
                  <xsl:variable name="numPools" select="PoolRoundFormat/NumPoolSize1 + PoolRoundFormat/NumPoolSize2" />
                  <xsl:if test="$numPools != 0">
                    <!-- Single size of pools -->
                    <xsl:if test ="PoolRoundFormat/NumPoolSize1 = 0 or PoolRoundFormat/NumPoolSize2 = 0">
                      <xsl:variable name="poolCount">
                        <xsl:if test="PoolRoundFormat/NumPoolSize1 = 0">
                          <xsl:value-of select="PoolRoundFormat/NumPoolSize2" />
                        </xsl:if>
                        <xsl:if test="PoolRoundFormat/NumPoolSize1 != 0">
                          <xsl:value-of select="PoolRoundFormat/NumPoolSize1" />
                        </xsl:if>
                      </xsl:variable>
                      <xsl:variable name="poolSize">
                        <xsl:if test="PoolRoundFormat/NumPoolSize1 = 0">
                          <xsl:value-of select="PoolRoundFormat/PoolSize2" />
                        </xsl:if>
                        <xsl:if test="PoolRoundFormat/NumPoolSize1 != 0">
                          <xsl:value-of select="PoolRoundFormat/PoolSize1" />
                        </xsl:if>
                      </xsl:variable>

                      <xsl:if test="$poolCount = 1">
                        <xsl:call-template name="FormatString">
                          <xsl:with-param name="localized" select="$localized" />
                          <xsl:with-param name="id"        select="'EF_OnePoolOfX'" />
                          <xsl:with-param name="arg1"      select="$poolSize" />
                        </xsl:call-template>
                      </xsl:if>
                      <xsl:if test="$poolCount &gt; 1">
                        <xsl:call-template name="FormatString">
                          <xsl:with-param name="localized" select="$localized" />
                          <xsl:with-param name="id"        select="'EF_PoolsOfX'" />
                          <xsl:with-param name="arg1"      select="$poolCount" />
                          <xsl:with-param name="arg2"      select="$poolSize" />
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:if>

                    <xsl:if test ="PoolRoundFormat/NumPoolSize1 != 0 and PoolRoundFormat/NumPoolSize2 != 0">
                      <!-- Different sizes, show total number of pools -->
                      <xsl:call-template name="FormatString">
                        <xsl:with-param name="localized" select="$localized" />
                        <xsl:with-param name="id"        select="'EF_NumPools'" />
                        <xsl:with-param name="arg1"      select="$numPools" />
                      </xsl:call-template>
                      <br/>

                      <xsl:choose>
                        <xsl:when test="PoolRoundFormat/NumPoolSize1 = 1 and PoolRoundFormat/NumPoolSize2 &gt; 1">
                          <xsl:call-template name="FormatString">
                            <xsl:with-param name="localized" select="$localized" />
                            <xsl:with-param name="id"        select="'EF_OnePoolOfXandY'" />
                            <xsl:with-param name="arg1"      select="PoolRoundFormat/PoolSize1" />
                            <xsl:with-param name="arg2"      select="PoolRoundFormat/NumPoolSize2" />
                            <xsl:with-param name="arg3"      select="PoolRoundFormat/PoolSize2" />
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="PoolRoundFormat/NumPoolSize1 &gt; 1 and PoolRoundFormat/NumPoolSize2 = 1">
                          <xsl:call-template name="FormatString">
                            <xsl:with-param name="localized" select="$localized" />
                            <xsl:with-param name="id"        select="'EF_PoolsOfXandOneOfY'" />
                            <xsl:with-param name="arg1"      select="PoolRoundFormat/NumPoolSize1" />
                            <xsl:with-param name="arg2"      select="PoolRoundFormat/PoolSize1" />
                            <xsl:with-param name="arg3"      select="PoolRoundFormat/PoolSize2" />
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="PoolRoundFormat/NumPoolSize1 = 1 and PoolRoundFormat/NumPoolSize2 = 1">
                          <xsl:call-template name="FormatString">
                            <xsl:with-param name="localized" select="$localized" />
                            <xsl:with-param name="id"        select="'EF_OnePoolOfXandOneOfY'" />
                            <xsl:with-param name="arg1"      select="PoolRoundFormat/PoolSize1" />
                            <xsl:with-param name="arg2"      select="PoolRoundFormat/PoolSize2" />
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:call-template name="FormatString">
                            <xsl:with-param name="localized" select="$localized" />
                            <xsl:with-param name="id"        select="'EF_PoolsOfXandY'" />
                            <xsl:with-param name="arg1"      select="PoolRoundFormat/NumPoolSize1" />
                            <xsl:with-param name="arg2"      select="PoolRoundFormat/PoolSize1" />
                            <xsl:with-param name="arg3"      select="PoolRoundFormat/NumPoolSize2" />
                            <xsl:with-param name="arg4"      select="PoolRoundFormat/PoolSize2" />
                          </xsl:call-template>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                  </xsl:if>

                  <xsl:if test="$numPools = 0">
                    <xsl:variable name="oneSize" select="(PoolRoundFormat/PoolSize1 = PoolRoundFormat/PoolSize2) or (PoolRoundFormat/NumPoolSize1 = 0) or (PoolRoundFormat/PoolSize1 = 0)" />
                    <xsl:if test="$oneSize">
                      <xsl:call-template name="FormatString">
                        <xsl:with-param name="localized" select="$localized" />
                        <xsl:with-param name="id"        select="'EF_NoNumPoolsOfX'" />
                        <xsl:with-param name="arg1"      select="PoolRoundFormat/PoolSize2" />
                      </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="not($oneSize)">
                      <xsl:call-template name="FormatString">
                        <xsl:with-param name="localized" select="$localized" />
                        <xsl:with-param name="id"        select="'EF_NoNumPoolsOfXandY'" />
                        <xsl:with-param name="arg1"      select="PoolRoundFormat/PoolSize1" />
                        <xsl:with-param name="arg2"      select="PoolRoundFormat/PoolSize2" />
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:if>
                  <br />

                  <!-- Promotion from pools -->
                  <xsl:variable name="promoteAll" select="PoolRoundFormat/NumToPromote &gt;= NumCompsInRound" />
                  <xsl:if test="$promoteAll">
                    <xsl:value-of select="$localized/ft:LocText[@id='EF_PromoteAll']" />
                  </xsl:if>
                  <xsl:if test="not($promoteAll)">
                    <xsl:call-template name="FormatString">
                      <xsl:with-param name="localized" select="$localized" />
                      <xsl:with-param name="id"        select="'EF_PromoteSome'" />
                      <xsl:with-param name="arg1"      select="PoolRoundFormat/NumToPromote" />
                      <xsl:with-param name="arg2"      select="format-number(PoolRoundFormat/NumToPromote * 100.0 div NumCompsInRound, '#.00')" />
                      <xsl:with-param name="arg3"      select="NumCompsInRound" />
                    </xsl:call-template>
                  </xsl:if>
                  <br />

                  <!-- Combined pools, if any -->
                  <xsl:if test="PoolRoundFormat/NumToCombine != 0">
                    <xsl:call-template name="FormatString">
                      <xsl:with-param name="localized" select="$localized" />
                      <xsl:with-param name="id"        select="'EF_CombinedResults'" />
                      <xsl:with-param name="arg1"      select="PoolRoundFormat/NumToCombine" />
                    </xsl:call-template>
                    <br />
                  </xsl:if>
                </xsl:if>

                <!-- Elimination round info -->
                <xsl:if test="ElimRoundFormat">
                  <xsl:choose>
                    <!-- Repechage -->
                    <xsl:when test="ElimRoundFormat/RepSize != 0">
                      <xsl:if test="ElimRoundFormat/CompleteTableau = 'true'">
                        <xsl:call-template name="FormatString">
                          <xsl:with-param name="localized" select="$localized" />
                          <xsl:with-param name="id"        select="'EF_CompleteDERep'" />
                          <xsl:with-param name="arg1"      select="ElimRoundFormat/TableSize" />
                          <xsl:with-param name="arg2"      select="ElimRoundFormat/RepSize" />
                        </xsl:call-template>
                      </xsl:if>
                      <xsl:if test="ElimRoundFormat/CompleteTableau = 'false'">
                        <xsl:call-template name="FormatString">
                          <xsl:with-param name="localized" select="$localized" />
                          <xsl:with-param name="id"        select="'EF_IncompleteDERep'" />
                          <xsl:with-param name="arg1"      select="ElimRoundFormat/TableSize" />
                          <xsl:with-param name="arg2"      select="ElimRoundFormat/RepSize" />
                        </xsl:call-template>
                      </xsl:if>
                      <br />
                      <xsl:value-of select="$localized/ft:LocText[@id='EF_NoFenceOff']" />
                    </xsl:when>

                    <!-- APF -->
                    <xsl:when test="ElimRoundFormat/APFSize != 0">
                      <xsl:if test="ElimRoundFormat/CompleteTableau = 'true'">
                        <xsl:call-template name="FormatString">
                          <xsl:with-param name="localized" select="$localized" />
                          <xsl:with-param name="id"        select="'EF_CompleteDEAPF'" />
                          <xsl:with-param name="arg1"      select="ElimRoundFormat/TableSize" />
                          <xsl:with-param name="arg2"      select="ElimRoundFormat/APFSize" />
                        </xsl:call-template>
                      </xsl:if>
                      <xsl:if test="ElimRoundFormat/CompleteTableau = 'false'">
                        <xsl:call-template name="FormatString">
                          <xsl:with-param name="localized" select="$localized" />
                          <xsl:with-param name="id"        select="'EF_IncompleteDEAPF'" />
                          <xsl:with-param name="arg1"      select="ElimRoundFormat/TableSize" />
                          <xsl:with-param name="arg2"      select="ElimRoundFormat/APFSize" />
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:when>

                    <!-- Single elimination -->
                    <xsl:otherwise>
                      <xsl:if test="ElimRoundFormat/CompleteTableau = 'true'">
                        <xsl:call-template name="FormatString">
                          <xsl:with-param name="localized" select="$localized" />
                          <xsl:with-param name="id"        select="'EF_CompleteDE'" />
                          <xsl:with-param name="arg1"      select="ElimRoundFormat/TableSize" />
                        </xsl:call-template>
                      </xsl:if>
                      <xsl:if test="ElimRoundFormat/CompleteTableau = 'false'">
                        <xsl:call-template name="FormatString">
                          <xsl:with-param name="localized" select="$localized" />
                          <xsl:with-param name="id"        select="'EF_IncompleteDE'" />
                          <xsl:with-param name="arg1"      select="ElimRoundFormat/TableSize" />
                        </xsl:call-template>
                      </xsl:if>
                      <xsl:text xml:space="preserve">&#160;</xsl:text>

                      <xsl:if test="ElimRoundFormat/DETo = 1">
                        <xsl:value-of select="$localized/ft:LocText[@id='EF_ThruFinals']" />
                        <br/>
                        <xsl:if test="ElimRoundFormat/FenceOff = 'true'">
                          <xsl:value-of select="$localized/ft:LocText[@id='EF_FenceOff']" />
                        </xsl:if>
                        <xsl:if test="ElimRoundFormat/FenceOff = 'false'">
                          <xsl:value-of select="$localized/ft:LocText[@id='EF_NoFenceOff']" />
                        </xsl:if>
                      </xsl:if>

                      <xsl:if test="ElimRoundFormat/DETo != 1">
                        <xsl:call-template name="FormatString">
                          <xsl:with-param name="localized" select="$localized" />
                          <xsl:with-param name="id"        select="'EF_FenceTo'" />
                          <xsl:with-param name="arg1"      select="ElimRoundFormat/DETo" />
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
              </div>
            </div>
          </xsl:for-each>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:include href="Transform\Common.xslt" />
</xsl:stylesheet>
