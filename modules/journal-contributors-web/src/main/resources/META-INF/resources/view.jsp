<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/init.jsp" %>

<nav class="a-items">
	<input class="activate hidden" id="contributors" name="contributors" type="checkbox" />

	<label class="accordion-label" for="contributors">Contributors</label>

	<div class="a-content sbox">
		<ul class="list-unstyled">
			<li>
				<span class="glyphicon glyphicon-eye-open"></span>
				<%= journalContributorsDisplayContext.getViewCount() %>
			</li>
			<li>
				<table class="contributors-table">
					<c:if test="<%= modifierContributor != null %>">
						<tr>
							<td>
								<span class="glyphicon glyphicon-user"></span>
								Updated by <a href="<%= modifierContributor.getUrl() %>"><%= modifierContributor.getName() %></a>
							</td>
							<td class="last-td">
								<span class="glyphicon glyphicon-calendar"></span>
								<%= journalContributorsDisplayContext.getModifiedDate() %>
							</td>
						</tr>
					</c:if>

					<c:if test="<%= creatorContributor != null %>">
						<tr>
							<td>
								<span class="glyphicon glyphicon-user"></span>
								Creator: <a href="<%= creatorContributor.getUrl() %>"><%= creatorContributor.getName() %></a> (<%= creatorContributor.getCount() %>)
							</td>
							<td class="last-td">
								<span class="glyphicon glyphicon-calendar"> </span>
								<%= journalContributorsDisplayContext.getCreateDate() %>
							</td>
						</tr>
					</c:if>
				</table>
			</li>

			<%
			for (Contributor contributor : journalContributorsDisplayContext.getContributors()) {
			%>

				<li>
					<span class="glyphicon glyphicon-user"></span>

					<a class="" data-animation="true" href="<%= contributor.getUrl() %>">
						<%= contributor.getName() %>
					</a> (<%= contributor.getCount() %>)
				</li>

			<%
			}
			%>

			<li>
				<span class="glyphicon glyphicon-list"></span>

				<a class="" href="<%= journalContributorsDisplayContext.getURLViewHistory() %>">View history</a>
			</li>
		</ul>
	</div>
</nav>