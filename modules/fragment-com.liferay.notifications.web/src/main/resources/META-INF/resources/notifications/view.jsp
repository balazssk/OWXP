<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * The contents of this file are subject to the terms of the Liferay Enterprise
 * Subscription License ("License"). You may not use this file except in
 * compliance with the License. You can obtain a copy of the License by
 * contacting Liferay, Inc. See the License for the specific language governing
 * permissions and limitations under the License, including but not limited to
 * distribution rights of the Software.
 *
 *
 *
 */
--%>

<%@ include file="/init.jsp" %>

<%@ page import="com.liferay.portal.kernel.model.UserNotificationDeliveryConstants" %><%@
page import="com.liferay.portal.kernel.portlet.PortalPreferences" %><%@
page import="com.liferay.portal.kernel.portlet.PortletPreferencesFactoryUtil" %><%@
page import="com.liferay.portal.kernel.service.UserNotificationEventLocalServiceUtil" %>

<%
_resetUserNoticationEventsCount(themeDisplay.getUserId());

int archivedUserNotificationEventsCount = UserNotificationEventLocalServiceUtil.getArchivedUserNotificationEventsCount(themeDisplay.getUserId(), UserNotificationDeliveryConstants.TYPE_WEBSITE, false, false);

String navigation = ParamUtil.getString(request, "navigation", "all");

boolean actionRequired = ParamUtil.getBoolean(request, "actionRequired");

if (actionRequired) {
	navigation = "unread";
}

SearchContainer notificationsSearchContainer = new SearchContainer(renderRequest, currentURLObj, null, actionRequired ? "you-do-not-have-any-requests" : "you-do-not-have-any-notifications");

String searchContainerId = "userNotificationEvents";

if (actionRequired) {
	searchContainerId = "actionableUserNotificationEvents";
}

notificationsSearchContainer.setId(searchContainerId);

NotificationsManagementToolbarDisplayContext notificationsManagementToolbarDisplayContext = new NotificationsManagementToolbarDisplayContext(liferayPortletRequest, liferayPortletResponse, request, currentURLObj);

NotificationsUtil.populateResults(themeDisplay.getUserId(), actionRequired, navigation, notificationsManagementToolbarDisplayContext.getOrderByType(), notificationsSearchContainer);

PortletURL navigationURL = PortletURLUtil.clone(currentURLObj, renderResponse);

navigationURL.setParameter(SearchContainer.DEFAULT_CUR_PARAM, "0");
%>

<clay:navigation-bar
	inverted="<%= true %>"
	navigationItems="<%=
		new JSPNavigationItemList(pageContext) {
			{
				add(
					navigationItem -> {
						navigationItem.setActive(!actionRequired);
						navigationItem.setHref(renderResponse.createRenderURL(), "actionRequired", StringPool.FALSE);
						navigationItem.setLabel(LanguageUtil.format(request, "notifications-list-x", UserNotificationEventLocalServiceUtil.getDeliveredUserNotificationEventsCount(themeDisplay.getUserId(), UserNotificationDeliveryConstants.TYPE_WEBSITE, true, false)));
					});

				add(
					navigationItem -> {

						navigationItem.setActive(actionRequired);
						navigationItem.setHref(renderResponse.createRenderURL(), "actionRequired", StringPool.TRUE);
						navigationItem.setLabel(LanguageUtil.format(request, "requests-list-x", String.valueOf(UserNotificationEventLocalServiceUtil.getArchivedUserNotificationEventsCount(themeDisplay.getUserId(), UserNotificationDeliveryConstants.TYPE_WEBSITE, true, false))));
					});
			}
		}
	%>"
/>

<clay:management-toolbar
	actionDropdownItems="<%= notificationsManagementToolbarDisplayContext.getActionDropdownItems() %>"
	componentId="notificationsManagementToolbar"
	disabled="<%= NotificationsUtil.getAllNotificationsCount(themeDisplay.getUserId(), actionRequired) == 0 %>"
	filterDropdownItems="<%= notificationsManagementToolbarDisplayContext.getFilterDropdownItems() %>"
	itemsTotal="<%= notificationsSearchContainer.getTotal() %>"
	searchContainerId="<%= searchContainerId %>"
	showCreationMenu="<%= false %>"
	showInfoButton="<%= false %>"
	showSearch="<%= false %>"
	sortingOrder="<%= notificationsManagementToolbarDisplayContext.getOrderByType() %>"
	sortingURL="<%= String.valueOf(notificationsManagementToolbarDisplayContext.getSortingURL()) %>"
/>

<div class="container-fluid-1280 main-content-body">
	<aui:form action="<%= currentURL %>" method="get" name="fm">
		<div class="user-notifications">
			<liferay-ui:search-container
				rowChecker="<%= new UserNotificationEventRowChecker(renderResponse) %>"
				searchContainer="<%= notificationsSearchContainer %>"
			>
				<liferay-ui:search-container-row
					className="com.liferay.portal.kernel.model.UserNotificationEvent"
					keyProperty="userNotificationEventId"
					modelVar="userNotificationEvent"
				>

					<%
					Map<String, Object> rowData = new HashMap<String, Object>();

					UserNotificationFeedEntry userNotificationFeedEntry = UserNotificationManagerUtil.interpret(StringPool.BLANK, userNotificationEvent, ServiceContextFactory.getInstance(request));

					rowData.put("userNotificationFeedEntry", userNotificationFeedEntry);

					row.setData(rowData);
					%>

					<%@ include file="/notifications/user_notification_entry.jspf" %>
				</liferay-ui:search-container-row>

				<liferay-ui:search-iterator
					displayStyle="descriptive"
					markupView="lexicon"
				/>
			</liferay-ui:search-container>
		</div>
	</aui:form>
</div>

<aui:script sandbox="<%= true %>">
	var deleteAllNotifications = function() {
		var form = AUI.$(document.<portlet:namespace />fm);

		form.attr('method', 'post');

		submitForm(form, '<portlet:actionURL name="deleteAllNotifications"><portlet:param name="redirect" value="<%= currentURL %>" /></portlet:actionURL>');
	};

	var markNotificationsAsRead = function() {
		var form = AUI.$(document.<portlet:namespace />fm);

		form.attr('method', 'post');

		submitForm(form, '<portlet:actionURL name="markNotificationsAsRead"><portlet:param name="redirect" value="<%= currentURL %>" /></portlet:actionURL>');
	};

	var markNotificationsAsUnread = function() {
		var form = AUI.$(document.<portlet:namespace />fm);

		form.attr('method', 'post');

		submitForm(form, '<portlet:actionURL name="markNotificationsAsUnread"><portlet:param name="redirect" value="<%= currentURL %>" /></portlet:actionURL>');
	};

	var ACTIONS = {
		'deleteAllNotifications': deleteAllNotifications,
		'markNotificationsAsRead': markNotificationsAsRead,
		'markNotificationsAsUnread': markNotificationsAsUnread
	};

	Liferay.componentReady('notificationsManagementToolbar').then(
		function(managementToolbar) {
			managementToolbar.on(
				'actionItemClicked',
				function(event) {
					var itemData = event.data.item.data;

					if (itemData && itemData.action && ACTIONS[itemData.action]) {
						ACTIONS[itemData.action]();
					}
				}
			);
		}
	);
</aui:script>

<aui:script use="aui-base,liferay-notice">
	var form = A.one('#<portlet:namespace />fm');

	form.delegate(
		'click',
		function(event) {
			event.preventDefault();

			var currentTarget = event.currentTarget;

			A.io.request(
				currentTarget.attr('href'),
				{
					dataType: 'JSON',
					on: {
						success: function() {
							var responseData = this.get('responseData');

							if (responseData.success) {
								var notificationContainer = currentTarget.ancestor('li.list-group-item');

								if (notificationContainer) {
									var markAsReadURL = notificationContainer.one('a').attr('href');

									form.attr('method', 'post');

									submitForm(form, markAsReadURL);

									notificationContainer.remove();
								}
							}
							else {
								getNotice().show();
							}
						}
					}
				}
			);
		},
		'.user-notification-action'
	);

	var notice;

	function getNotice() {
		if (!notice) {
			notice = new Liferay.Notice(
				{
					closeText: false,
					content: '<liferay-ui:message key="an-unexpected-error-occurred" /><button class="close" type="button">&times;</button>',
					timeout: 5000,
					toggleText: false,
					type: 'warning',
					useAnimation: false
				}
			);
		}

		return notice;
	}
</aui:script>

<%!
private void _resetUserNoticationEventsCount(long userId) {
	PortalPreferences portalPreferences =
		PortletPreferencesFactoryUtil.getPortalPreferences(userId, true);

	portalPreferences.setValue(
		UserNotificationEvent.class.getName(),
		"useLegacyUserNotificationEventsCount", "false");

	portalPreferences.setValue(
		UserNotificationEvent.class.getName(),
		"userNotificationEventsCount", "0");
}
%>