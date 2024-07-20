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
        password= "GITHUB_TOKEN "
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
        password= "GITHUB_TOKEN "
    }
}
    }
}
```

2. Go to your_project/android/app/build.gradle and add this line.

```
android {
	compileSdk 33
	defaultConfig {
	// other code
		minSdkVersion 24
		targetSdkVersion 33
		multiDexEnabled true
	}
}
```




