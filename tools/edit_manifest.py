#!/usr/bin/env python3
# Edits an apktool-decoded stock DuckStation 12010 AndroidManifest.xml in place.
import sys

p = sys.argv[1]
s = open(p, encoding="utf-8").read()


def once(old, new, count=1):
    global s
    if s.count(old) != count:
        sys.exit("manifest anchor not found %d time(s): %s" % (count, old.strip()[:80]))
    s = s.replace(old, new)


PERMS = (
    '    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE"/>\n'
    '    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>\n'
    '    <uses-permission android:maxSdkVersion="29" android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>\n'
)
once('    <uses-permission android:name="android.permission.VIBRATE"/>\n',
     '    <uses-permission android:name="android.permission.VIBRATE"/>\n' + PERMS)

once('android:label="@string/app_name"', 'android:label="DuckStation FS"', count=2)

FILTERS = """            <intent-filter>
                <action android:name="android.intent.action.VIEW"/>
                <action android:name="com.github.stenzek.duckstation.LAUNCH"/>
                <category android:name="android.intent.category.DEFAULT"/>
                <category android:name="android.intent.category.BROWSABLE"/>
                <data android:scheme="file"/>
                <data android:scheme="content"/>
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.VIEW"/>
                <action android:name="com.github.stenzek.duckstation.LAUNCH"/>
                <category android:name="android.intent.category.DEFAULT"/>
                <data android:scheme="file"/>
                <data android:scheme="content"/>
                <data android:mimeType="*/*"/>
            </intent-filter>
            <intent-filter>
                <action android:name="com.github.stenzek.duckstation.LAUNCH"/>
                <category android:name="android.intent.category.DEFAULT"/>
            </intent-filter>
"""
anchor = '            <meta-data android:name="android.support.PARENT_ACTIVITY"'
once(anchor, FILTERS + anchor)

PROVIDER = ('        <provider android:authorities="com.github.stenzek.duckstation.frontend-init" '
            'android:exported="false" android:initOrder="100" '
            'android:name="com.github.stenzek.duckstation.FrontendInit"/>\n')
anchor = '        <uses-library android:name="androidx.window.extensions"'
once(anchor, PROVIDER + anchor)

open(p, "w", encoding="utf-8").write(s)
