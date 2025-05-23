/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the Friendship type in your schema. */
class Friendship extends amplify_core.Model {
  static const classType = const _FriendshipModelType();
  final String id;
  final User? _initiator;
  final User? _recipient;
  final FriendshipStatus? _status;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  FriendshipModelIdentifier get modelIdentifier {
      return FriendshipModelIdentifier(
        id: id
      );
  }
  
  User? get initiator {
    return _initiator;
  }
  
  User? get recipient {
    return _recipient;
  }
  
  FriendshipStatus get status {
    try {
      return _status!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Friendship._internal({required this.id, initiator, recipient, required status, createdAt, updatedAt}): _initiator = initiator, _recipient = recipient, _status = status, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Friendship({String? id, User? initiator, User? recipient, required FriendshipStatus status}) {
    return Friendship._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      initiator: initiator,
      recipient: recipient,
      status: status);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Friendship &&
      id == other.id &&
      _initiator == other._initiator &&
      _recipient == other._recipient &&
      _status == other._status;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Friendship {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("initiator=" + (_initiator != null ? _initiator!.toString() : "null") + ", ");
    buffer.write("recipient=" + (_recipient != null ? _recipient!.toString() : "null") + ", ");
    buffer.write("status=" + (_status != null ? amplify_core.enumToString(_status)! : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Friendship copyWith({User? initiator, User? recipient, FriendshipStatus? status}) {
    return Friendship._internal(
      id: id,
      initiator: initiator ?? this.initiator,
      recipient: recipient ?? this.recipient,
      status: status ?? this.status);
  }
  
  Friendship copyWithModelFieldValues({
    ModelFieldValue<User?>? initiator,
    ModelFieldValue<User?>? recipient,
    ModelFieldValue<FriendshipStatus>? status
  }) {
    return Friendship._internal(
      id: id,
      initiator: initiator == null ? this.initiator : initiator.value,
      recipient: recipient == null ? this.recipient : recipient.value,
      status: status == null ? this.status : status.value
    );
  }
  
  Friendship.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _initiator = json['initiator'] != null
        ? json['initiator']['serializedData'] != null
          ? User.fromJson(new Map<String, dynamic>.from(json['initiator']['serializedData']))
          : User.fromJson(new Map<String, dynamic>.from(json['initiator']))
        : null,
      _recipient = json['recipient'] != null
        ? json['recipient']['serializedData'] != null
          ? User.fromJson(new Map<String, dynamic>.from(json['recipient']['serializedData']))
          : User.fromJson(new Map<String, dynamic>.from(json['recipient']))
        : null,
      _status = amplify_core.enumFromString<FriendshipStatus>(json['status'], FriendshipStatus.values),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'initiator': _initiator?.toJson(), 'recipient': _recipient?.toJson(), 'status': amplify_core.enumToString(_status), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'initiator': _initiator,
    'recipient': _recipient,
    'status': _status,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<FriendshipModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<FriendshipModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final INITIATOR = amplify_core.QueryField(
    fieldName: "initiator",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static final RECIPIENT = amplify_core.QueryField(
    fieldName: "recipient",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Friendship";
    modelSchemaDefinition.pluralName = "Friendships";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PRIVATE,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["initiatorId"], name: "byUser")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Friendship.INITIATOR,
      isRequired: false,
      targetNames: ['initiatorId'],
      ofModelName: 'User'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Friendship.RECIPIENT,
      isRequired: false,
      targetNames: ['recipientId'],
      ofModelName: 'User'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Friendship.STATUS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _FriendshipModelType extends amplify_core.ModelType<Friendship> {
  const _FriendshipModelType();
  
  @override
  Friendship fromJson(Map<String, dynamic> jsonData) {
    return Friendship.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Friendship';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Friendship] in your schema.
 */
class FriendshipModelIdentifier implements amplify_core.ModelIdentifier<Friendship> {
  final String id;

  /** Create an instance of FriendshipModelIdentifier using [id] the primary key. */
  const FriendshipModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'FriendshipModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is FriendshipModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}