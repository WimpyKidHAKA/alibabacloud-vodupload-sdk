#!/bin/sh

#PROJECT_NAME='AliyunOSSiOS'
PROJECT_NAME='VODUpload'
SRCROOT='.'

# Sets the target folders and the final framework product.
FMK_NAME=${PROJECT_NAME}

# Install dir will be the final output to the framework.
# The following line create it in the root folder of the current project.
INSTALL_DIR=${SRCROOT}/${PROJECT_NAME}.framework

# Working dir will be deleted after the framework creation.
WRK_DIR=build
DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework

# -configuration ${CONFIGURATION}
# Clean and Building both architectures.
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos clean build
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator clean build

# Cleaning the oldest.
if [ -d "${INSTALL_DIR}" ]
then
    rm -rf "${INSTALL_DIR}"
fi

cp -R "${DEVICE_DIR}" "${INSTALL_DIR}"

# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"

rm -r "${WRK_DIR}"

if [ -d "${INSTALL_DIR}/_CodeSignature" ]
then
    rm -rf "${INSTALL_DIR}/_CodeSignature"
fi

if [ -f "${INSTALL_DIR}/Info.plist" ]
then
    rm "${INSTALL_DIR}/Info.plist"
fi
