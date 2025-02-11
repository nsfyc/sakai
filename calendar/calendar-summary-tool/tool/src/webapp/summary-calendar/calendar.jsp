<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h"%>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f"%>
<%@ taglib uri="http://sakaiproject.org/jsf2/sakai" prefix="sakai"%>

<% 
	response.setContentType("text/html; charset=UTF-8");
	response.addDateHeader("Expires", System.currentTimeMillis() - (1000L * 60L * 60L * 24L * 365L));
	response.addDateHeader("Last-Modified", System.currentTimeMillis());
	response.addHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0, post-check=0, pre-check=0");
	response.addHeader("Pragma", "no-cache");
%>

<f:view>
<sakai:view title="#{msgs.tool_title}" id="sakaiview">
	
	<h:outputText value="#{CalBean.initValues}"/>

	<h:form id="calendarForm" styleClass="Mrphs-calendarSynoptic">
	<h:panelGroup>
		<sakai:tool_bar rendered="#{CalBean.userId ne null && CalBean.preferencesVisible}">
			<h:commandLink action="#{MenuBean.processPreferences}" >
				<h:outputText value="#{CalBean.accessibleOptionsLink}" escape="false"/>
            </h:commandLink>
			<h:commandLink rendered="#{MenuBean.subscribeEnabled}" action="#{MenuBean.processSubscribe}" >
                <h:outputText value="#{msgs['java.opaque_subscribe']}" escape="false"/>
            </h:commandLink>
		</sakai:tool_bar>
    </h:panelGroup>

	<f:verbatim><div style="width:100%" id="div100"></f:verbatim>
		<h:panelGrid styleClass="sectionContainerNav" style="width:100%" columns="2" columnClasses="calLeft,calRight" id="panelgrid_top"> 		
			<f:subview id="title">
				<f:verbatim><h3 style="text-align: left; white-space: nowrap;"></f:verbatim><h:outputText value="#{CalBean.caption}"/><f:verbatim></h3></f:verbatim>
			</f:subview>

	        <h:panelGroup>
                <f:verbatim><fieldset><legend></f:verbatim><h:outputText value="#{msgs.previous}"/><f:verbatim></legend></f:verbatim>
                    <h:commandButton id="id_left_month" value=" < " actionListener="#{CalBean.prev}" title="#{msgs.a11y_last_month}" rendered="#{(CalBean.viewMode eq 'month') or (empty CalBean.viewMode)}" immediate="true"/>
                    <h:commandButton id="id_left_week" value=" < " actionListener="#{CalBean.prev}" title="#{msgs.a11y_last_week}" rendered="#{CalBean.viewMode eq 'week'}" immediate="true"/>
                <f:verbatim></fieldset></f:verbatim>
                <h:commandButton value="#{msgs.today}" actionListener="#{CalBean.currDay}" title="#{msgs.today}" immediate="true" styleClass="todayButton" />
                <f:verbatim><fieldset><legend></f:verbatim><h:outputText value="#{msgs.next}"/><f:verbatim></legend></f:verbatim>
                    <h:commandButton id="id_right_month" value=" > " actionListener="#{CalBean.next}" title="#{msgs.a11y_next_month}" rendered="#{(CalBean.viewMode eq 'month') or (empty CalBean.viewMode)}" immediate="true"/>
                    <h:commandButton id="id_right_week" value=" > " actionListener="#{CalBean.next}" title="#{msgs.a11y_next_week}" rendered="#{CalBean.viewMode eq 'week'}" immediate="true"/>
                <f:verbatim></fieldset></f:verbatim>
	        </h:panelGroup>

            <script type="text/javascript">
                window.onload = load;
                function load() {
                    var my_left_month = document.getElementById("calendarForm:id_left_month");
                    var my_right_month = document.getElementById("calendarForm:id_right_month");
                    var my_left_week = document.getElementById("calendarForm:id_left_week");
                    var my_right_week = document.getElementById("calendarForm:id_right_week");
                    if (my_left_month!=null) {my_left_month.setAttribute("aria-label", document.getElementById("calendarForm:id_left_month").getAttribute("title"));}
                    if (my_right_month!=null) {my_right_month.setAttribute("aria-label", document.getElementById("calendarForm:id_right_month").getAttribute("title"));}
                    if (my_left_week!=null) {my_left_week.setAttribute("aria-label", document.getElementById("calendarForm:id_left_week").getAttribute("title"));}
                    if (my_right_week!=null) {my_right_week.setAttribute("aria-label", document.getElementById("calendarForm:id_right_week").getAttribute("title"));}
                }
            </script>

		</h:panelGrid>

		<h:dataTable
			id="table_calendar"
			value="#{CalBean.calendar}"
			var="week"
			styleClass="mainCalendar"
			headerClass="calHeader"
			columnClasses="calDay,calDay,calDay,calDay,calDay,calDay,calDay"
			>
			<h:column id="sunday">
				<f:facet name="header">	 
		           <h:outputText value="#{CalBean.dayOfWeekNames[0]}" />		          
		        </f:facet>
		        <h:panelGroup style="#{week.days[0].backgroundCSSProperty}" styleClass="#{week.days[0].styleClass}">
			        <h:commandLink value="#{week.days[0].dayOfMonth}" actionListener="#{CalBean.selectDate}" rendered="#{week.days[0].hasEvents}" immediate="true">
			        	<f:param name="selectedDay" value="#{week.days[0].dateAsString}"/>
			        </h:commandLink>
			        <h:outputText value="#{week.days[0].dayOfMonth}" rendered="#{!week.days[0].hasEvents}" />
				</h:panelGroup>
			</h:column>
			<h:column id="monday">
				<f:facet name="header">	 
		           <h:outputText value="#{CalBean.dayOfWeekNames[1]}"/>		                
		        </f:facet>		        
		        <h:panelGroup style="#{week.days[1].backgroundCSSProperty}" styleClass="#{week.days[1].styleClass}">
			        <h:commandLink value="#{week.days[1].dayOfMonth}" actionListener="#{CalBean.selectDate}" rendered="#{week.days[1].hasEvents}" immediate="true">
			        	<f:param name="selectedDay" value="#{week.days[1].dateAsString}"/>
			        </h:commandLink>
			        <h:outputText value="#{week.days[1].dayOfMonth}" rendered="#{!week.days[1].hasEvents}" />
				</h:panelGroup>
			</h:column>
			<h:column id="tuesday">
				<f:facet name="header">	 
		           <h:outputText value="#{CalBean.dayOfWeekNames[2]}"/>		                
		        </f:facet>		        
		        <h:panelGroup style="#{week.days[2].backgroundCSSProperty}" styleClass="#{week.days[2].styleClass}">
			        <h:commandLink value="#{week.days[2].dayOfMonth}" actionListener="#{CalBean.selectDate}" rendered="#{week.days[2].hasEvents}" immediate="true">
			        	<f:param name="selectedDay" value="#{week.days[2].dateAsString}"/>
			        </h:commandLink>
			        <h:outputText value="#{week.days[2].dayOfMonth}" rendered="#{!week.days[2].hasEvents}" />
				</h:panelGroup>
			</h:column>
			<h:column id="wednesday">
				<f:facet name="header">	 
		           <h:outputText value="#{CalBean.dayOfWeekNames[3]}"/>		                
		        </f:facet>		        
		        <h:panelGroup style="#{week.days[3].backgroundCSSProperty}" styleClass="#{week.days[3].styleClass}">
			        <h:commandLink value="#{week.days[3].dayOfMonth}" actionListener="#{CalBean.selectDate}" rendered="#{week.days[3].hasEvents}" immediate="true">
			        	<f:param name="selectedDay" value="#{week.days[3].dateAsString}"/>
			        </h:commandLink>
			        <h:outputText value="#{week.days[3].dayOfMonth}" rendered="#{!week.days[3].hasEvents}" />
				</h:panelGroup>
			</h:column>
			<h:column id="thursday">
				<f:facet name="header">	 
		           <h:outputText value="#{CalBean.dayOfWeekNames[4]}"/>		                
		        </f:facet>
		        <h:panelGroup style="#{week.days[4].backgroundCSSProperty}" styleClass="#{week.days[4].styleClass}">
			        <h:commandLink value="#{week.days[4].dayOfMonth}" actionListener="#{CalBean.selectDate}" rendered="#{week.days[4].hasEvents}" immediate="true">
			        	<f:param name="selectedDay" value="#{week.days[4].dateAsString}"/>
			        </h:commandLink>
			        <h:outputText value="#{week.days[4].dayOfMonth}" rendered="#{!week.days[4].hasEvents}" />
				</h:panelGroup>
			</h:column>
			<h:column id="friday">
				<f:facet name="header">	 
		           <h:outputText value="#{CalBean.dayOfWeekNames[5]}"/>		                
		        </f:facet>
		        <h:panelGroup style="#{week.days[5].backgroundCSSProperty}" styleClass="#{week.days[5].styleClass}">
			        <h:commandLink value="#{week.days[5].dayOfMonth}" actionListener="#{CalBean.selectDate}" rendered="#{week.days[5].hasEvents}" immediate="true">
			        	<f:param name="selectedDay" value="#{week.days[5].dateAsString}"/>
			        </h:commandLink>
			        <h:outputText value="#{week.days[5].dayOfMonth}" rendered="#{!week.days[5].hasEvents}" />
				</h:panelGroup>
			</h:column>
			<h:column id="saturday">
				<f:facet name="header">	 
		           <h:outputText value="#{CalBean.dayOfWeekNames[6]}"/>		                
		        </f:facet>
		        <h:panelGroup style="#{week.days[6].backgroundCSSProperty}" styleClass="#{week.days[6].styleClass}">
			        <h:commandLink value="#{week.days[6].dayOfMonth}" actionListener="#{CalBean.selectDate}" rendered="#{week.days[6].hasEvents}" immediate="true">
			        	<f:param name="selectedDay" value="#{week.days[6].dateAsString}"/>
			        </h:commandLink>
			        <h:outputText value="#{week.days[6].dayOfMonth}" rendered="#{!week.days[6].hasEvents}" />
				</h:panelGroup>
			</h:column>
		</h:dataTable>
		
		
		<%/* Selected day events */%>
		<h:panelGroup id="div_event_list" styleClass="calendarEventListContainer" rendered="#{CalBean.viewingSelectedDay}">
			<f:verbatim><h4></f:verbatim><h:outputText value="#{msgs.selectedDayEvents} #{CalBean.selectedDayAsString}"/><f:verbatim></h4></f:verbatim>
			<h:dataTable
				id="datalist_event_list"
				value="#{CalBean.selectedDayEvents}"
				var="event"
				styleClass="calendarEventList"
				>
				<h:column id="one_column">
					<h:outputText value="#{CalBean.eventIconMap[event.type]}" escape="false"/>
					<h:outputText value=" #{event.typeLocalized} - "/>
				    <h:commandLink value="#{event.truncatedDisplayName}" actionListener="#{CalBean.selectEvent}" immediate="true">
				       	<f:param name="calendarRef" value="#{event.calendarRef}"/>
				       	<f:param name="eventRef" value="#{event.eventRef}"/>
				    </h:commandLink>
                    <h:outputText value=" (#{event.site})"/>
				    <h:graphicImage value="#{CalBean.imgLocation}/attachments.gif" rendered="#{event.hasAttachments}" alt="#{msgs.attachments}"/>
				</h:column>		        	
		    </h:dataTable>
		</h:panelGroup>
		
		<%/* Selected event */%>
		<h:panelGroup id="div_selected_event" rendered="#{CalBean.viewingSelectedEvent}">
			<f:verbatim><h4></f:verbatim><h:outputText value="#{CalBean.selectedEvent.displayName}"/><f:verbatim></h4></f:verbatim>

			<div class="mx-3">
				<h:panelGrid id="panel_selected_event_error" styleClass="sectionContainerNav" style="width:100%; padding-top: 5px;" columns="1" columnClasses="calTop" rendered="#{CalBean.selectedEvent.openDateError}">
					<h:outputText value="#{msgs['java.alert.opendate']} #{CalBean.selectedEvent.openDateErrorDescription}"
											  styleClass="sak-banner-error"/>
					<h:panelGroup styleClass="act" style="display: block">
						<h:commandButton value="#{msgs.back}" actionListener="#{CalBean.backToEventList}" immediate="true"/>
					</h:panelGroup>
				</h:panelGrid>
				<h:panelGrid id="panel_selected_event" styleClass="sectionContainerNav" style="width:100%; padding-top: 5px;" columns="2" columnClasses="calTop,calTop" rendered="#{not CalBean.selectedEvent.openDateError}">
					<h:outputLabel for="date" value="#{msgs.date}" />
					<h:outputText id="date" value="#{CalBean.selectedEvent.date}" />
					<h:outputLabel for="type" value="#{msgs.type}" />
					<h:panelGroup>
						<h:outputText value="#{CalBean.eventIconMap[CalBean.selectedEvent.type]}" escape="false"/>
						<h:outputText id="type" value="#{CalBean.selectedEvent.typeLocalized}" style="padding-left: 3px;"/>
					</h:panelGroup>
					<h:outputLabel for="description" value="#{msgs.description}" rendered="#{CalBean.selectedEvent.description ne ''}"/>
					<h:outputText id="description" value="#{CalBean.selectedEvent.description}" escape="false" rendered="#{CalBean.selectedEvent.description ne ''}"/>

					<f:verbatim><p></f:verbatim><f:verbatim><p></f:verbatim>
					<h:outputLabel for="location" value="#{msgs.location}" rendered="#{CalBean.selectedEvent.hasLocation}" />
					<h:outputText id="location" value="#{CalBean.selectedEvent.location}" rendered="#{CalBean.selectedEvent.hasLocation}" />
					<h:outputLabel for="groups" value="#{msgs.groups}" rendered="#{CalBean.selectedEvent.showGroups}" />
					<h:outputText id="groups" value="#{CalBean.selectedEvent.groups}" rendered="#{CalBean.selectedEvent.showGroups}" />
					<h:outputLabel for="site" value="#{msgs.site}" />
					<h:outputText id="site" value="#{CalBean.selectedEvent.site}" />
					<h:outputLabel for="attachments" value="#{msgs.attachments}" rendered="#{CalBean.selectedEvent.hasAttachments}"/>
					<h:dataTable
						id="attachments"
						value="#{CalBean.selectedEvent.attachmentsWrapper}"
						var="attach"
						style="width:100%"
						rendered="#{CalBean.selectedEvent.hasAttachments}"
						>
						<h:column id="one_column">
							<h:outputLink value="#{attach.url}" target="_blank">
								<h:outputText value="#{attach.displayName}"/>
							</h:outputLink>
							<h:graphicImage value="#{CalBean.imgLocation}/attachments.gif" alt="#{msgs.attachments}"/>
							<%--<f:verbatim><br></f:verbatim>--%>
						</h:column>
					</h:dataTable>
					<f:verbatim><p></f:verbatim><f:verbatim><p></f:verbatim><f:verbatim><p></f:verbatim>
					<h:outputLink value="#{CalBean.selectedEvent.url}" rendered="#{CalBean.selectedEvent.url != null}" target="_parent">
						<h:outputText value="#{msgs.openInSchedule}"/>
					</h:outputLink>

					<h:panelGroup styleClass="act" style="display: block">
						<h:commandButton value="#{msgs.back}" actionListener="#{CalBean.backToEventList}" immediate="true"/>
					</h:panelGroup>
					<f:verbatim>&nbsp;</f:verbatim>
				</h:panelGrid>
			</div>
		</h:panelGroup>
		
	<%--</h:panelGroup>--%>
	<f:verbatim></div></f:verbatim>
	
	</h:form>
</sakai:view>
</f:view>
