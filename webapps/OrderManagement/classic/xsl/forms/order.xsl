<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="../templates/form.xsl"/>
    <xsl:import href="../templates/sharedactions.xsl"/>
    <xsl:variable name="doctype"></xsl:variable>
    <xsl:variable name="threaddocid" select="document/@docid"/>
    <xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
    <xsl:variable name="skin" select="request/@skin"/>
    <xsl:variable name="lang" select="request/@lang"/>
    <xsl:variable name="readonly" select="request/document/@editmde"/>
    <xsl:variable name="editmode"><xsl:value-of select="/request/document/@editmode"/></xsl:variable>
        <xsl:template match="/request">
            <html>
                <head>
                    <title>OrderManagment - <xsl:value-of select="document/captions/title/@caption" /></title>
                    <!-- load scripts and css link -->
                    <xsl:call-template name="cssandjs"/>
                    <xsl:call-template name="hotkeys"/>
                    <xsl:call-template name="htmlareaeditor"/>
                    <xsl:call-template name="calendar"/>
                </head>
                <body>
                    <xsl:attribute name="onbeforeprint">javascript:$("#htmlcodenoteditable").html($("#txtDefaultHtmlArea").val())</xsl:attribute>
                    <xsl:variable name="status" select="@status"/>
                    <div id="docwrapper">
                        <xsl:call-template name="documentheader"/>
                        <div class="formwrapper">
                            <div class="formtitle">
                                <div class="title">

                                    <xsl:value-of select="document/fields/title" />
                                </div>
                            </div>
                            <!-- Сохранить и закрыть -->
                            <div class="button_panel">
                                <span style="float:left">
                                    <xsl:call-template name="save"/>
                                </span>
                                <!-- Закрыть -->
                                <span style="float:right; padding-right:15px;">
                                    <xsl:call-template name="cancel"/>
                                </span>

                            </div>
                            <div style="clear:both"/>
                            <div style="-moz-border-radius:0px;height:1px; width:100%; "/>
                            <div style="clear:both"/>
                            <div id="tabs">
                                <form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
                                    <ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
                                        <li class="ui-state-default ui-corner-top">
                                            <a href="#tabs-1">
                                                <xsl:value-of select="document/captions/properties/@caption"/>
                                            </a>
                                        </li>
                                        <xsl:call-template name="docInfo"/>
                                    </ul>

                                    <div class="ui-tabs-panel" id="tabs-1" >
                                        <div display="block"  id="property" width="100%">
                                            <table border="0" style="margin-top:8px">

                                                <!-- Номер заказа  -->

                                                <!-- Дата заказа  -->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/regDate/@caption" />: </font></td>
                                                    <td style="width:70%">
                                                        <input type="text" required="required"  class="td_editable" style="width:200px" name="orderDate">
                                                            <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                            <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                            <xsl:attribute name="title" select="document/fields/orderDate/@caption" />
                                                            <xsl:attribute name="value" select="document/fields/orderDate" />
                                                        </input>
                                                    </td>
                                                </tr>

                                                <!-- Название компании -->
                                                <tr>
                                                    <td  class="fc"><xsl:value-of select="document/captions/customer/@caption" />: </td>
                                                    <td colspan="3" >
                                                        <xsl:if test="document/@editmode ='edit'">
                                                            <select size="1" name="customer" style="width:600px;" id="category" class="select_editable">
                                                                <xsl:variable name="customer" select="document/fields/customer/@attrval" />
                                                                <xsl:for-each select="document/glossaries/customer/entry">
                                                                    <option value="{@id}">
                                                                        <xsl:if test="$customer = @id">
                                                                            <xsl:attribute name="selected">selected</xsl:attribute>
                                                                        </xsl:if>
                                                                        <xsl:value-of  select="."/>
                                                                    </option>
                                                                </xsl:for-each>
                                                            </select>
                                                        </xsl:if>
                                                        <xsl:if test="document/@editmode !='edit'">
                                                            <div style="width:590px;" class="title">
                                                                <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                                <xsl:value-of  select="document/fields/customer"/>
                                                            </div>
                                                        </xsl:if>
                                                    </td>
                                                </tr>

                                                <!-- Ответственный -->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/responsiblePerson/@caption"/>:
                                                        <xsl:if test="document/@editmode = 'edit'">
                                                            <a accesskey="3" style="cursor:pointer">
                                                                <xsl:attribute name="onclick">javascript:dialogBoxStructure('executers','false','responsiblePerson','frm', 'responsiblePersontbl');</xsl:attribute>
                                                                <img src="/SharedResources/img/classic/picklist.gif"/>
                                                            </a>
                                                        </xsl:if>
                                                    </font>
                                                    </td>
                                                    <td>
                                                        <table id="responsiblePersontbl" width="500px">
                                                            <xsl:if test="document/@status != 'new'">
                                                                <tr>
                                                                    <td style="border:1px solid #ccc; margin-top:2px" class="td_editable">
                                                                        <xsl:value-of select="document/fields/responsiblePerson" />&#xA0;
                                                                        <input type="hidden" id="responsiblePerson" name="responsiblePerson">
                                                                            <xsl:attribute name="value" select="document/fields/responsiblePerson/@attrval"/>
                                                                        </input>
                                                                        <!--<xsl:if test="$editmode='edit'">-->
                                                                            <!--<img onclick="delmember(this)" src="/SharedResources/img/iconset/cross.png" style="width:15px; height:15px; margin-right:3px; margin-top:1px; float:right; cursor:pointer"/>-->
                                                                        <!--</xsl:if>-->
                                                                    </td>
                                                                </tr>
                                                            </xsl:if>
                                                            <xsl:if test="document/@status = 'new'">
                                                                <tr>
                                                                    <td style="border:1px solid #ccc; margin-top:2px" class="td_editable">
                                                                        &#xA0;
                                                                    </td>
                                                                </tr>
                                                            </xsl:if>
                                                        </table>
                                                        <input type="hidden" id="responsiblePersoncaption" value="{document/captions/responsiblePerson/@caption}"/>
                                                    </td>
                                                </tr>

                                                <!-- Дата выйдачи -->
                                                <tr>
                                                    <td  class="fc">
                                                        <font style="vertical-align:top">
                                                            <xsl:value-of select="document/captions/issueDate/@caption"/>:
                                                        </font>
                                                    </td>
                                                    <td>
                                                        <input type="text" id="issueDate"  name="issueDate" class="td_noteditable" style="width:100px; vertical-align:top">
                                                            <xsl:attribute name="title" select="document/captions/issueDate/@caption" />
                                                            <xsl:attribute name="value" select="substring(document/fields/issueDate,1,10)" />
                                                            <xsl:if test="document/@editmode = 'edit'">
                                                                <xsl:attribute name="class">eventdate</xsl:attribute>
                                                            </xsl:if>
                                                        </input>
                                                    </td>
                                                </tr>

                                                <!--  Наименование товаров -->
                                                <tr>
                                                    <td  class="fc">
                                                        <font style="vertical-align:top">
                                                            <xsl:value-of select="document/captions/goodsList/@caption"/>:
                                                        </font>
                                                    </td>
                                                    <td>
                                                        <textarea class="td_editable" name="goodsList" style="width:590px; vertical-align:top; max-width:1200px" >
                                                            <xsl:if test="document/@editmode != 'edit'">
                                                                <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                                <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:attribute name="title" select="document/captions/goodsList/@caption" />
                                                            <xsl:value-of select="document/fields/goodsList" />
                                                        </textarea>
                                                    </td>
                                                </tr>

                                                <!-- Цена за единицу  -->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/price/@caption" />: </font></td>
                                                    <td style="width:70%">
                                                        <input type="text" name="price" class="td_editable" style="width:200px">
                                                            <xsl:if test="document/@editmode != 'edit'">
                                                                <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                                <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:attribute name="title" select="document/captions/price/@caption" />
                                                            <xsl:attribute name="value" select="document/fields/price" />
                                                        </input> KZT
                                                    </td>
                                                </tr>

                                                <!-- Количество -->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/quantity/@caption" />: </font></td>
                                                    <td style="width:70%">
                                                        <input type="text" maxlength="10" name="quantity" class="td_editable" style="width:200px">
                                                            <xsl:if test="document/@editmode != 'edit'">
                                                                <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                                <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:attribute name="title" select="document/captions/quantity/@caption" />
                                                            <xsl:attribute name="value" select="document/fields/quantity" />
                                                            <xsl:attribute name="onkeydown">javascript:numericfield(this)</xsl:attribute>
                                                        </input>
                                                    </td>
                                                </tr>

                                                <!-- Сумма  -->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/totalPrice/@caption" />: </font></td>
                                                    <td style="width:70%">
                                                        <input type="text" name="totalPrice" class="td_editable" style="width:200px">
                                                            <xsl:if test="document/@editmode != 'edit'">
                                                                <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                                <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:attribute name="title" select="document/captions/totalPrice/@caption" />
                                                            <xsl:attribute name="value" select="document/fields/totalPrice" />
                                                        </input> KZT
                                                    </td>
                                                </tr>

                                                <!-- предоплата -->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/prepayment/@caption" />: </font></td>
                                                    <td style="width:70%">
                                                        <input type="text" name="prepayment" class="td_editable" style="width:200px">
                                                            <xsl:if test="document/@editmode != 'edit'">
                                                                <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                                <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:attribute name="title" select="document/captions/prepayment/@caption" />
                                                            <xsl:attribute name="value" select="document/fields/prepayment" />
                                                        </input> KZT
                                                    </td>
                                                </tr>

                                                <!-- остаток -->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/leftPayment/@caption" />: </font></td>
                                                    <td style="width:70%">
                                                        <input type="text" name="leftPayment" class="td_editable" style="width:200px">
                                                            <xsl:if test="document/@editmode != 'edit'">
                                                                <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                                <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:attribute name="title" select="document/captions/leftPayment/@caption" />
                                                            <xsl:attribute name="value" select="document/fields/leftPayment" />
                                                        </input> KZT
                                                    </td>
                                                </tr>


                                                <!-- Ссылка на смету -->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/linkToOutlay/@caption" />: </font></td>
                                                    <td style="width:70%">
                                                        <input type="text" name="linkToOutlay" class="td_editable" style="width:590px">
                                                            <xsl:if test="document/@editmode != 'edit'">
                                                                <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                                <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:attribute name="title" select="document/captions/linkToOutlay/@caption" />
                                                            <xsl:attribute name="value" select="document/fields/linkToOutlay" />
                                                        </input>
                                                    </td>
                                                </tr>

                                                <!-- Ссылка на модел -->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/linkToModel/@caption" />: </font></td>
                                                    <td style="width:70%">
                                                        <input type="text" name="linkToModel" class="td_editable" style="width:590px">
                                                            <xsl:if test="document/@editmode != 'edit'">
                                                                <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                                <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:attribute name="title" select="document/captions/linkToModel/@caption" />
                                                            <xsl:attribute name="value" select="document/fields/linkToModel" />
                                                        </input>
                                                    </td>
                                                </tr>

                                                <!-- фактическая стоимость закупа -->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/purchaseCost/@caption" />: </font></td>
                                                    <td style="width:70%">
                                                        <input type="text" name="purchaseCost" class="td_editable" style="width:200px">
                                                            <xsl:if test="document/@editmode != 'edit'">
                                                                <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                                <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:attribute name="title" select="document/captions/purchaseCost/@caption" />
                                                            <xsl:attribute name="value" select="document/fields/purchaseCost" />
                                                        </input> KZT
                                                    </td>
                                                </tr>

                                                <!-- фактическая стоимость закупа -->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/contractorCost/@caption" />: </font></td>
                                                    <td style="width:70%">
                                                        <input type="text" name="contractorCost" class="td_editable" style="width:200px">
                                                            <xsl:if test="document/@editmode != 'edit'">
                                                                <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                                <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:attribute name="title" select="document/captions/contractorCost/@caption" />
                                                            <xsl:attribute name="value" select="document/fields/contractorCost" />
                                                        </input> KZT
                                                    </td>
                                                </tr>

                                                <!-- Фактическая стоимость рабочей силы-->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/laborCost/@caption" />: </font></td>
                                                    <td style="width:70%">
                                                        <input type="text" name="laborCost" class="td_editable" style="width:200px">
                                                            <xsl:if test="document/@editmode != 'edit'">
                                                                <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                                <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:attribute name="title" select="document/captions/laborCost/@caption" />
                                                            <xsl:attribute name="value" select="document/fields/laborCost" />
                                                        </input> KZT
                                                    </td>
                                                </tr>

                                                <!--прибыль-->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/profit/@caption" />: </font></td>
                                                    <td style="width:70%">
                                                        <input type="text" name="profit" class="td_editable" style="width:200px">
                                                            <xsl:if test="document/@editmode != 'edit'">
                                                                <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                                <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:attribute name="title" select="document/captions/profit/@caption" />
                                                            <xsl:attribute name="value" select="document/fields/profit" />
                                                        </input> KZT
                                                    </td>
                                                </tr>

                                                <!-- Макет-->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/model/@caption" />: </font></td>
                                                    <td style="width:70%">
                                                        <input type="text" name="model" class="td_editable" style="width:590px">
                                                            <xsl:if test="document/@editmode != 'edit'">
                                                                <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                                <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:attribute name="title" select="document/captions/model/@caption" />
                                                            <xsl:attribute name="value" select="document/fields/model" />
                                                        </input>
                                                    </td>
                                                </tr>

                                                <!--workerCode-->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/workerCode/@caption" />: </font></td>
                                                    <td style="width:70%">
                                                        <input type="text" name="workerCode" class="td_editable" style="width:590px">
                                                            <xsl:if test="document/@editmode != 'edit'">
                                                                <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                                <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:attribute name="title" select="document/captions/workerCode/@caption" />
                                                            <xsl:attribute name="value" select="document/fields/workerCode" />
                                                        </input>
                                                    </td>
                                                </tr>

                                                <!-- credit -->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/credit/@caption" /> :</font></td>
                                                    <td>
                                                        <input type="checkbox" id="credit"  name="credit" autocomplete="off">
                                                            <xsl:if test="document/fields/credit ='on'">
                                                                <xsl:attribute name="checked">checked</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:if test="$editmode != 'edit'">
                                                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                                                            </xsl:if>
                                                        </input>
                                                    </td>
                                                </tr>

                                                <!-- Наличие подписанного акта -->
                                                <tr>
                                                    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/signedAct/@caption" /> :</font></td>
                                                    <td>
                                                        <input type="checkbox" id="signedAct"  name="signedAct" autocomplete="off">
                                                            <xsl:if test="document/fields/signedAct ='on'">
                                                                <xsl:attribute name="checked">checked</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:if test="$editmode != 'edit'">
                                                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                                                            </xsl:if>
                                                        </input>
                                                    </td>
                                                </tr>
                                            </table>
                                            <input type="hidden" name="type" value="save"/>
                                            <input type="hidden" name="id" value="{@id}"/>
                                            <input type="hidden" name="key" value="{document/@docid}"/>
                                            <input type="hidden" name="parentdocid" value="{document/@parentdocid}"/>
                                            <input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/>
                                            <input type="hidden" name="doctype" value="{document/@doctype}"/>
                                            <input type="hidden" name="formsesid" value="{formsesid}"/>

                                        </div>
                                    </div>
                                </form>

                            </div>
                        </div>
                    </div>
                    <!-- Outline -->
                    <xsl:call-template name="formoutline"/>
                </body>
            </html>
    </xsl:template>

    <xsl:template name="lang_splitter">
        <xsl:param name="param"/>
        &#xA0;
        <xsl:variable name="kaz_part" select="substring-before($param, '/*')" />
        <xsl:variable name="rus_part" select="substring-after($param, '/*')" />

        <xsl:choose>
            <xsl:when test="$lang = 'KAZ'">
                <xsl:value-of select="$kaz_part" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$rus_part" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>