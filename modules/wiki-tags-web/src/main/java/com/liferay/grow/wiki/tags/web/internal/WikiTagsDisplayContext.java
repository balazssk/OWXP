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

package com.liferay.grow.wiki.tags.web.internal;

import com.liferay.asset.kernel.model.AssetEntry;
import com.liferay.asset.kernel.model.AssetTag;
import com.liferay.asset.kernel.service.AssetEntryLocalService;
import com.liferay.asset.kernel.service.AssetTagLocalService;
import com.liferay.wiki.constants.WikiWebKeys;
import com.liferay.wiki.model.WikiPage;

import java.util.Iterator;
import java.util.List;

import javax.portlet.RenderResponse;
import javax.portlet.RenderURL;

import javax.servlet.http.HttpServletRequest;

import org.osgi.service.component.annotations.Reference;

/**
 * @author Balázs Sáfrány-Kovalik
 */
public class WikiTagsDisplayContext {

	public WikiTagsDisplayContext(
		HttpServletRequest request, RenderResponse renderResponse) {

		_wikiPage = (WikiPage)request.getAttribute(WikiWebKeys.WIKI_PAGE);

		_assetEntry = _assetEntryLocalService.fetchEntry(
			WikiPage.class.getName(), _wikiPage.getResourcePrimKey());

		_renderResponse = renderResponse;
	}

	public String getTagRenderURL(String tagName) {
		RenderURL tagRenderURL = _renderResponse.createRenderURL();

		tagRenderURL.setParameter(
			"mvcRenderCommandName", "/wiki/view_tagged_pages");
		tagRenderURL.setParameter(
			"nodeId", String.valueOf(_wikiPage.getNodeId()));
		tagRenderURL.setParameter("tag", tagName);

		return tagRenderURL.toString();
	}

	public List<AssetTag> getUnofficialTags() {
		if (_unofficialTags != null) {
			return _unofficialTags;
		}

		_unofficialTags = _assetTagLocalService.getAssetEntryAssetTags(
			_assetEntry.getEntryId());

		Iterator<AssetTag> i = _unofficialTags.iterator();

		while (i.hasNext()) {
			AssetTag tag = i.next();

			String tagName = tag.getName();

			tagName = tagName.toLowerCase();

			if (tagName.equals("official")) {
				_official = true;
				i.remove();
			}
		}

		return _unofficialTags;
	}

	public boolean hasOfficial() {
		if (_official != null) {
			return _official;
		}

		_official = false;

		getUnofficialTags();

		return _official;
	}

	public boolean hasTags() {
		if (_hasTags != null) {
			return _hasTags;
		}

		_hasTags = false;

		if (_assetTagLocalService.getAssetEntryAssetTagsCount(
				_assetEntry.getEntryId()) > 0) {

			_hasTags = true;
		}

		return _hasTags;
	}

	private AssetEntry _assetEntry;

	@Reference
	private AssetEntryLocalService _assetEntryLocalService;

	@Reference
	private AssetTagLocalService _assetTagLocalService;

	private Boolean _hasTags;
	private Boolean _official;
	private RenderResponse _renderResponse;
	private List<AssetTag> _unofficialTags;
	private WikiPage _wikiPage;

}