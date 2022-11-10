package com.example.myapplication

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

class AddActivity: AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.add_view_activity)
    }

    fun add_item(view: View) {
        var correct = true
        val nameText = findViewById<EditText>(R.id.nameInput).text.toString()
        val quantityText = findViewById<EditText>(R.id.quantityInput).text.toString()
        val priceText = findViewById<EditText>(R.id.priceInput).text.toString()
        val categoryText = findViewById<EditText>(R.id.categoryInput).text.toString()
        val noteText = findViewById<EditText>(R.id.noteInput).text.toString()

        if (nameText == "") {
            Toast.makeText(this,"You must add product name!", Toast.LENGTH_LONG).show()
            correct = false
        }
        if (quantityText == "") {
            Toast.makeText(this,"You must add quantity!", Toast.LENGTH_LONG).show()
            correct = false
        }
        if (priceText == ""){
            Toast.makeText(this,"You must add the price!", Toast.LENGTH_LONG).show()
            correct = false
        }
        if (categoryText == "") {
            Toast.makeText(this,"You must add a category", Toast.LENGTH_LONG).show()
            correct = false
        }
        if (noteText == "") {
            Toast.makeText(this,"You must add a note!", Toast.LENGTH_LONG).show()
            correct = false
        }
        if (priceText.toInt() < 0){
            Toast.makeText(this,"Price must be positive number!", Toast.LENGTH_LONG).show()
            correct = false
        }
        if (quantityText.toInt() < 0){
            Toast.makeText(this,"Quantity must be positive number!", Toast.LENGTH_LONG).show()
            correct = false
        }


        val item = Item(nameText, quantityText.toInt(), priceText.toInt() , categoryText, noteText)

        if (correct) {
            val intent = Intent()
            val bundle = Bundle()
            bundle.putParcelable("item", item)
            intent.putExtra("itemBundle", bundle)
            setResult(RESULT_OK, intent)
            finish()
        }
    }

    fun go_back(view: View) {
        intent = Intent()
        finish()
    }
}