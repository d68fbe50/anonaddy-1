// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      fromName: json['from_name'] as String? ?? '',
      emailSubject: json['email_subject'] as String? ?? '',
      bannerLocation: json['banner_location'] as String? ?? '',
      bandwidth: json['bandwidth'] as int? ?? 0,
      bandwidthLimit: json['bandwidth_limit'] as int? ?? 0,
      usernameCount: json['username_count'] as int? ?? 0,
      usernameLimit: json['username_limit'] as int? ?? 0,
      defaultRecipientId: json['default_recipient_id'] as String? ?? '',
      defaultAliasDomain: json['default_alias_domain'] as String? ?? '',
      defaultAliasFormat: json['default_alias_format'] as String? ?? '',
      subscription: json['subscription'] as String? ?? '',
      subscriptionEndAt: json['subscription_ends_at'] as String? ?? '',
      recipientCount: json['recipient_count'] as int? ?? 0,
      recipientLimit: json['recipient_limit'] as int? ?? 0,
      activeDomainCount: json['active_domain_count'] as int? ?? 0,
      activeDomainLimit: json['active_domain_limit'] as int? ?? 0,
      aliasCount: json['active_shared_domain_alias_count'] as int? ?? 0,
      aliasLimit: json['active_shared_domain_alias_limit'] as int? ?? 0,
      totalEmailsForwarded: json['total_emails_forwarded'] as int? ?? 0,
      totalEmailsBlocked: json['total_emails_blocked'] as int? ?? 0,
      totalEmailsReplied: json['total_emails_replied'] as int? ?? 0,
      totalEmailsSent: json['total_emails_sent'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      lastUpdated: json['updated_at'] as String? ?? '',
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'from_name': instance.fromName,
      'email_subject': instance.emailSubject,
      'banner_location': instance.bannerLocation,
      'bandwidth': instance.bandwidth,
      'bandwidth_limit': instance.bandwidthLimit,
      'username_count': instance.usernameCount,
      'username_limit': instance.usernameLimit,
      'default_recipient_id': instance.defaultRecipientId,
      'default_alias_domain': instance.defaultAliasDomain,
      'default_alias_format': instance.defaultAliasFormat,
      'subscription': instance.subscription,
      'subscription_ends_at': instance.subscriptionEndAt,
      'recipient_count': instance.recipientCount,
      'recipient_limit': instance.recipientLimit,
      'active_domain_count': instance.activeDomainCount,
      'active_domain_limit': instance.activeDomainLimit,
      'active_shared_domain_alias_count': instance.aliasCount,
      'active_shared_domain_alias_limit': instance.aliasLimit,
      'total_emails_forwarded': instance.totalEmailsForwarded,
      'total_emails_blocked': instance.totalEmailsBlocked,
      'total_emails_replied': instance.totalEmailsReplied,
      'total_emails_sent': instance.totalEmailsSent,
      'created_at': instance.createdAt,
      'updated_at': instance.lastUpdated,
    };
