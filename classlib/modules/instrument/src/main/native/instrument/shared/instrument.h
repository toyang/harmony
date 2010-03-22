/* 
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jvmti.h>
#include <jni.h>
/* Header for class org_apache_harmony_instrument_internal_InstrumentationImpl */

#ifndef _Included_org_apache_harmony_instrument_internal_InstrumentationImpl
#define _Included_org_apache_harmony_instrument_internal_InstrumentationImpl
#ifdef __cplusplus
extern "C" {
#endif

typedef struct{
	jvmtiEnv *jvmti;
	jobject *inst;
	jclass *inst_class;
	jmethodID *transform_method;
	jmethodID *premain_method;
} AgentData;

typedef struct AgentList{
	char *class_name;
	char *option;
	struct AgentList *next;
}AgentList;

AgentList list;
AgentData *gdata;
	
/*
 * Class:     org_apache_harmony_instrument_internal_InstrumentationImpl
 * Method:    redefineClasses_native
 * Signature: ([Ljava/lang/instrument/ClassDefinition;)V
 */
JNIEXPORT void JNICALL Java_org_apache_harmony_instrument_internal_InstrumentationImpl_redefineClasses_1native
  (JNIEnv *, jobject, jobjectArray);

/*
 * Class:     org_apache_harmony_instrument_internal_InstrumentationImpl
 * Method:    getAllLoadedClasses
 * Signature: ()[Ljava/lang/Class;
 */
JNIEXPORT jobjectArray JNICALL Java_org_apache_harmony_instrument_internal_InstrumentationImpl_getAllLoadedClasses
  (JNIEnv *, jobject);

/*
 * Class:     org_apache_harmony_instrument_internal_InstrumentationImpl
 * Method:    getInitiatedClasses
 * Signature: (Ljava/lang/ClassLoader;)[Ljava/lang/Class;
 */
JNIEXPORT jobjectArray JNICALL Java_org_apache_harmony_instrument_internal_InstrumentationImpl_getInitiatedClasses
  (JNIEnv *, jobject, jobject);

/*
 * Class:     org_apache_harmony_instrument_internal_InstrumentationImpl
 * Method:    getObjectSize_native
 * Signature: (Ljava/lang/Object;)J
 */
JNIEXPORT jlong JNICALL Java_org_apache_harmony_instrument_internal_InstrumentationImpl_getObjectSize_1native
  (JNIEnv *, jobject, jobject);

void check_jvmti_error(JNIEnv *, jvmtiError, const char *);
#ifdef __cplusplus
}
#endif
#endif
