package com.example.myapplication

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class DetailsActivity: AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.details_view_activity)
        val item = intent.getParcelableExtra("item") as Item?
        show_details(item)
    }

    fun show_details(item: Item?){
        if (item != null) {
            findViewById<TextView>(R.id.nameInput).setText(item.name)
            findViewById<TextView>(R.id.quantityInput).setText(item.quantity)
            findViewById<TextView>(R.id.priceInput).setText(item.price)
            findViewById<TextView>(R.id.categoryInput).setText(item.category)
            findViewById<TextView>(R.id.noteInput).setText(item.note)
        }
    }

    fun go_back(view: View) {
        intent = Intent()
        finish()
    }
}