package com.fadimanos.istamnabwaqtih

import android.app.Activity
import android.os.Bundle
import android.widget.TextView
import android.graphics.Color
import android.view.Gravity

class MainActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
            
        // Create a TextView programmatically
        val textView = TextView(this).apply {
            text = "مرحباً بك في\nالاستمناء بوقته\n\nتم البناء بنجاح بواسطة fadimanos!"
            textSize = 24f
            setTextColor(Color.BLACK)
            gravity = Gravity.CENTER
        }
            
        // Set the content view to our text view
        setContentView(textView)
    }
}
