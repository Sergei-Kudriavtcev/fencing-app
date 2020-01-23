<?xml version="1.0" encoding="utf-8"?>
<!-- 
Fencing Time
By Daniel Berke
(C) Copyright by Daniel Berke 
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ft="http://www.fencingtime.com">
  <xsl:output indent="yes" encoding="UTF-8" />
  <xsl:variable name="fileVersion">4.4</xsl:variable>

  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>USFA Event Classification Chart</title>
        <style type="text/css">
          <xsl:comment>
            .listlabels {
              background-color: #333355;
              font-family: Arial, Helvetica, sans-serif;
              font-size: 12px;
              font-weight: bold;
              color: #ffffff;
            }
            h1 {
              font-family: Arial, Helvetica, sans-serif;
              font-size: 24px;
            }
            .footer {
              font-family: Arial, Helvetica, sans-serif;
              font-size: 12px;
            }
            .evenrow {
              background-color: #eef2f6;
              font-family: Arial, Helvetica, sans-serif;
              font-size: 12px;
            }
            .oddrow {
              background-color: #dde9f6;
              font-family: Arial, Helvetica, sans-serif;
              font-size: 12px;
            }
            .title {
              font-family: Arial, Helvetica, sans-serif;
              font-size: 18px;
              color: #000033;
            }
          </xsl:comment>
        </style>
      </head>

      <body>
        <h1>USFA Event Classification Chart</h1>
        <p class="footer">
          This chart is current as of <xsl:value-of select="/ft:EventClassificationChart/ft:EffectiveDate/@AsOf" />
        </p>
        <table border="0" cellspacing="1" cellpadding="5">
          <tr align="center" class="listlabels">
            <th rowspan="1">Event</th>
            <th rowspan="1">Minimum<br/>Fencers</th>
            <th rowspan="1">Rated<br/>Fencers<br/>Required</th>
            <th rowspan="1">Rated<br/>Fencers<br/>Must<br/>Finish</th>
            <th colspan="2" rowspan="1">Classifications<br/>Awarded</th>
          </tr>

          <xsl:for-each select="/ft:EventClassificationChart/ft:Group">
            <tr align="center">
              <xsl:attribute name="class">
                <xsl:if test="position() mod 2 = 0">evenrow</xsl:if>
                <xsl:if test="position() mod 2 = 1">oddrow</xsl:if>
              </xsl:attribute>
              <th>Group <xsl:value-of select="@name" /></th>
              <td><xsl:value-of select="@minfencers" /></td>
              <td align="left">
                <xsl:call-template name="fenReq">
                  <xsl:with-param name="fencers" select="ft:RatedFencersRequired/ft:Fencers" />
                </xsl:call-template>
              </td>
              <td align="left">
                <xsl:call-template name="mustFinish">
                  <xsl:with-param name="finish" select="ft:RatedMustFinish/ft:Top" />
                </xsl:call-template>
              </td>
              <td align="right">
                <xsl:call-template name="awardPlace">
                  <xsl:with-param name="places" select="ft:ClassificationsAwarded/ft:Place" />
                </xsl:call-template>
              </td>
              <td align="left">
                <xsl:call-template name="awardRating">
                  <xsl:with-param name="ratings" select="ft:ClassificationsAwarded/ft:Place" />
                </xsl:call-template>
              </td>
            </tr>
          </xsl:for-each>
          
        </table>

        <p class="footer">
          <xsl:for-each select="/ft:EventClassificationChart/ft:NationalEventOverride">
           <xsl:if test="contains(@level, '(')">
             <xsl:value-of select="substring-before(@level, '(')" />
           </xsl:if>
            <xsl:if test="not(contains(@level, '('))">
              <xsl:value-of select="@level" />
            </xsl:if>
            NAC and National Championships are always 
            <xsl:if test="@atleast!='A4'">at least</xsl:if>
            Group <xsl:value-of select="@atleast" /> competitions.<br/>
          </xsl:for-each>
        </p>

        <br/>
        <br/>
      
        <p class="footer">
          Table format courtesy of <a href="http://www.askfred.net">AskFred.net</a>
        </p>

      </body>
    </html>
  </xsl:template>

  <xsl:template name="fenReq">
    <xsl:param name="fencers" />
    <xsl:if test="count($fencers)=0">NONE</xsl:if>
    <xsl:if test="count($fencers)>0">
      <xsl:for-each select="$fencers">
        <xsl:value-of select="@count"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@rating"/>
        <xsl:text>'s</xsl:text>
        <xsl:if test="position() != last()">
          <xsl:text> &amp;</xsl:text>
        </xsl:if>
        <br/>
      </xsl:for-each>
      <xsl:text>(or higher)</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="mustFinish">
    <xsl:param name="finish" />
    <xsl:if test="count($finish)=0">N/A</xsl:if>
    <xsl:if test="count($finish)>0">
      <xsl:for-each select="$finish">
        <xsl:for-each select="ft:Fencers">
          <xsl:value-of select="@count" />
          <xsl:text> </xsl:text>
          <xsl:value-of select="@rating"/>
          <xsl:text>'s</xsl:text>
          <xsl:if test="position() != last()">
            <xsl:text> &amp;</xsl:text>
          </xsl:if>
          <br/>
        </xsl:for-each>
        <xsl:text>(or higher)</xsl:text>
        <br/>
        <xsl:text>in top </xsl:text>
        <xsl:value-of select="@num" />

        <xsl:if test="position() != last()">
          <xsl:text> &amp;</xsl:text>
        </xsl:if>
        <br/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="awardPlace">
    <xsl:param name="places" />
    <xsl:for-each select="$places">
      <xsl:if test="@start = @end">
        <xsl:value-of select="@start" />
      </xsl:if>
      <xsl:if test="@start != @end">
        <xsl:value-of select="@start"/>-<xsl:value-of select="@end"/>
      </xsl:if>
      <br/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="awardRating">
    <xsl:param name="ratings" />
    <xsl:for-each select="$ratings">
      <xsl:value-of select="@rating" />
      <br/>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet> 
