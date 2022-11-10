package com.example.myapplication

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import java.util.*

class EditActivity: AppCompatActivity() {
    private var position: Int = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.edit_view_activity)
        val item = intent.getParcelableExtra("item") as Item?
        val aux = intent.getIntExtra("position", 0)
        if (aux != 0) this.position=aux
        init_inputs(item)
    }

    fun init_inputs(item: Item?){
        if (item != null) {
            findViewById<TextView>(R.id.nameInput).setText(item.name)
            findViewById<TextView>(R.id.quantityInput).setText(item.quantity.toString())
            findViewById<TextView>(R.id.priceInput).setText(item.price.toString())
            findViewById<TextView>(R.id.categoryInput).setText(item.category)
            findViewById<TextView>(R.id.noteInput).setText(item.note)
        }
    }

    fun edit_item(view: View) {
        var correct = true
        val nameText = findViewById<EditText>(R.id.nameInput).text.toString()
        val quantityText = findViewById<EditText>(R.id.quantityInput).text.toString()
        val priceText = findViewById<EditText>(R.id.priceInput).text.toString()
        val categoryText = findViewById<EditText>(R.id.categoryInput).text.toString()
        val noteText = findViewById<EditText>(R.id.noteInput).text.toString()

        if (nameText == "") {
            Toast.makeText(this,"You must add a name!", Toast.LENGTH_LONG).show()
            correct = false
        }
        if (quantityText == "") {
            Toast.makeText(this,"You must add a quantity!", Toast.LENGTH_LONG).show()
            correct = false
        }
        if (priceText == ""){
            Toast.makeText(this,"You must add the price!", Toast.LENGTH_LONG).show()
            correct = false
        }
        if (categoryText == "") {
            Toast.makeText(this,"You must add a category!", Toast.LENGTH_LONG).show()
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

        val editedItem = Item(nameText, quantityText.toInt(), priceText.toInt(), categoryText, noteText)

        if(correct){
            val intent = Intent()
            intent.putExtra("item", editedItem)
            intent.putExtra("position", this.position)
            setResult(RESULT_OK,intent)
            finish()
        }
    }

    fun go_back(view: View) {
        intent = Intent()
        finish()
    }
}