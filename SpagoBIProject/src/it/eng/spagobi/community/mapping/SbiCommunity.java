/* SpagoBI, the Open Source Business Intelligence suite

 * Copyright (C) 2012 Engineering Ingegneria Informatica S.p.A. - SpagoBI Competency Center
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, without the "Incompatible With Secondary Licenses" notice. 
 * If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. */
package it.eng.spagobi.community.mapping;

// Generated 15-lug-2013 11.45.55 by Hibernate Tools 3.4.0.CR1

import it.eng.spagobi.commons.metadata.SbiHibernateModel;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import com.fasterxml.jackson.annotation.JsonManagedReference;

/**
 * SbiCommunity generated by hbm2java
 */
public class SbiCommunity extends SbiHibernateModel {

	private Integer communityId;
	private String name;
	private String description;
	private String owner;
	private String functCode;
	private Date creationDate;
	private Date lastChangeDate;
	private String userIn;
	private String userUp;
	private String userDe;
	private Date timeIn;
	private Date timeUp;
	private Date timeDe;
	private String sbiVersionIn;
	private String sbiVersionUp;
	private String sbiVersionDe;
	private String metaVersion;
	private String organization;
	@JsonManagedReference
	private Set sbiCommunityUserses = new HashSet(0);

	public SbiCommunity() {
	}

	public SbiCommunity(String name, String owner, Date creationDate,
			Date lastChangeDate, String userIn, Date timeIn) {
		this.name = name;
		this.owner = owner;
		this.creationDate = creationDate;
		this.lastChangeDate = lastChangeDate;
		this.userIn = userIn;
		this.timeIn = timeIn;
	}

	public SbiCommunity(String name, String description, String owner,
			String functCode, Date creationDate, Date lastChangeDate,
			String userIn, String userUp, String userDe, Date timeIn,
			Date timeUp, Date timeDe, String sbiVersionIn, String sbiVersionUp,
			String sbiVersionDe, String metaVersion, String organization,
			Set sbiCommunityUserses) {
		this.name = name;
		this.description = description;
		this.owner = owner;
		this.functCode = functCode;
		this.creationDate = creationDate;
		this.lastChangeDate = lastChangeDate;
		this.userIn = userIn;
		this.userUp = userUp;
		this.userDe = userDe;
		this.timeIn = timeIn;
		this.timeUp = timeUp;
		this.timeDe = timeDe;
		this.sbiVersionIn = sbiVersionIn;
		this.sbiVersionUp = sbiVersionUp;
		this.sbiVersionDe = sbiVersionDe;
		this.metaVersion = metaVersion;
		this.organization = organization;
		this.sbiCommunityUserses = sbiCommunityUserses;
	}

	public Integer getCommunityId() {
		return this.communityId;
	}

	public void setCommunityId(Integer communityId) {
		this.communityId = communityId;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getOwner() {
		return this.owner;
	}

	public void setOwner(String owner) {
		this.owner = owner;
	}

	public String getFunctCode() {
		return this.functCode;
	}

	public void setFunctCode(String functCode) {
		this.functCode = functCode;
	}

	public Date getCreationDate() {
		return this.creationDate;
	}

	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
	}

	public Date getLastChangeDate() {
		return this.lastChangeDate;
	}

	public void setLastChangeDate(Date lastChangeDate) {
		this.lastChangeDate = lastChangeDate;
	}

	public String getUserIn() {
		return this.userIn;
	}

	public void setUserIn(String userIn) {
		this.userIn = userIn;
	}

	public String getUserUp() {
		return this.userUp;
	}

	public void setUserUp(String userUp) {
		this.userUp = userUp;
	}

	public String getUserDe() {
		return this.userDe;
	}

	public void setUserDe(String userDe) {
		this.userDe = userDe;
	}

	public Date getTimeIn() {
		return this.timeIn;
	}

	public void setTimeIn(Date timeIn) {
		this.timeIn = timeIn;
	}

	public Date getTimeUp() {
		return this.timeUp;
	}

	public void setTimeUp(Date timeUp) {
		this.timeUp = timeUp;
	}

	public Date getTimeDe() {
		return this.timeDe;
	}

	public void setTimeDe(Date timeDe) {
		this.timeDe = timeDe;
	}

	public String getSbiVersionIn() {
		return this.sbiVersionIn;
	}

	public void setSbiVersionIn(String sbiVersionIn) {
		this.sbiVersionIn = sbiVersionIn;
	}

	public String getSbiVersionUp() {
		return this.sbiVersionUp;
	}

	public void setSbiVersionUp(String sbiVersionUp) {
		this.sbiVersionUp = sbiVersionUp;
	}

	public String getSbiVersionDe() {
		return this.sbiVersionDe;
	}

	public void setSbiVersionDe(String sbiVersionDe) {
		this.sbiVersionDe = sbiVersionDe;
	}

	public String getMetaVersion() {
		return this.metaVersion;
	}

	public void setMetaVersion(String metaVersion) {
		this.metaVersion = metaVersion;
	}

	public String getOrganization() {
		return this.organization;
	}

	public void setOrganization(String organization) {
		this.organization = organization;
	}

	public Set getSbiCommunityUserses() {
		return this.sbiCommunityUserses;
	}

	public void setSbiCommunityUserses(Set sbiCommunityUserses) {
		this.sbiCommunityUserses = sbiCommunityUserses;
	}

}
