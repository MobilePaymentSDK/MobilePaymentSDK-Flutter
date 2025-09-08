# Mobile Payment SDK for Flutter

• In pubspec.yaml:

```
dependencies:
  mobile_payment_plugin:
	git
	  url: https://github.com/MobilePaymentSDK/MobilePaymentSDK-Flutter.git
	  ref: main
```

* For Android
1.	Go to your_project/android/build.gradle and add this line

```
buildscript {
    repositories {
        // other repositories
        maven{
    url uri("https://maven.pkg.github.com/MobilePaymentSDK/MobilePaymentSDK-Android")
    credentials{
        username = "GITHUB_USERNAME"
        password= "GITHUB_TOKEN"
    }
}
    }
    // other dependencies
}


allprojects {
    repositories {
        // other repositories
        maven{
    url uri("https://maven.pkg.github.com/MobilePaymentSDK/MobilePaymentSDK-Android")
    credentials{
        username = "GITHUB_USERNAME"
        password= "GITHUB_TOKEN"
    }
}
    }
}
```

2. Go to your_project/android/app/build.gradle and add this line.

```
android {
	compileSdk 35
	defaultConfig {
	// other code for Java code
		minSdkVersion 24
		targetSdkVersion 35
		multiDexEnabled true
	}

	// After android block
	configurations.all {
   	 	exclude group: "com.squareup.okio", module: "okio-jvm"
    	exclude group: "com.squareup.okio", module: "okio"
	}
}
```

```
android {
compileSdk = 35
// for Kotlin code
defaultConfig {
    // other code
    minSdkVersion 24
    targetSdkVersion 35
    multiDexEnabled true
	}
}
// After android block
configurations.all {
    exclude(group = "com.squareup.okio", module = "okio-jvm")
    exclude(group = "com.squareup.okio", module = "okio")
}
```




