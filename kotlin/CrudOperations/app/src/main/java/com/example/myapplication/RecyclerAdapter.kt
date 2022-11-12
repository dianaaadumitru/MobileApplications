package com.example.myapplication

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView


class RecyclerAdapter(private val dogs: MutableList<Dog>):
    RecyclerView.Adapter<RecyclerAdapter.ViewHolder>() {
    private var context: Context? = null
    private final var intent: Intent? = null

    inner class ViewHolder(itemView: View): RecyclerView.ViewHolder(itemView), View.OnLongClickListener {

        val itemName: TextView = itemView.findViewById(R.id.Name)
        val itemBreed: TextView = itemView.findViewById(R.id.Breed)
        val itemYearOfBirth: TextView = itemView.findViewById(R.id.YearOfBirth)
        val itemArrivalDate: TextView = itemView.findViewById(R.id.ArrivalDate)
        val itemMedicalDetails: TextView = itemView.findViewById(R.id.MedicalDetails)
        val itemCrateNo: TextView = itemView.findViewById(R.id.CrateNumber)
        val itemDelete: ImageView = itemView.findViewById(R.id.delete)
        val itemEdit: ImageView = itemView.findViewById(R.id.edit)

        init {
            context = itemView.context
            itemView.setOnLongClickListener(this)
        }

        override fun onLongClick(view: View?): Boolean {
            // Handle long click
            // Return true to indicate the click was handled
//            val context = view?.context
//            val intent = Intent(context, DetailsActivity::class.java)
//            intent.putExtra("item", dogs[adapterPosition])
//            if (context != null) {
//                context.startActivity(intent)
//            }
            return true
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val v = LayoutInflater.from(parent.context).inflate(R.layout.list_item_view, parent, false)
        return ViewHolder(v)
    }

    override fun getItemCount(): Int {
        return dogs.size
    }

    @SuppressLint("NotifyDataSetChanged")
    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.itemName.text = dogs[position].name
        holder.itemBreed.text = dogs[position].breed
        holder.itemYearOfBirth.text = dogs[position].yearOfBirth.toString()
        holder.itemArrivalDate.text = dogs[position].arrivalDate
        holder.itemMedicalDetails.text = dogs[position].medicalDetails
        holder.itemCrateNo.text = dogs[position].crateNo.toString()


        holder.itemDelete.setOnClickListener{v: View ->
            val dialog = Dialog(v.context)
            dialog.setCancelable(true)
            dialog.setContentView(R.layout.delete_popup)
            val title = dialog.findViewById(R.id.titleLabel) as TextView
            var str = dogs.get(position).name
            str += "?"
            title.text = str
            val yesView = dialog.findViewById(R.id.yesButton) as View
            val noView = dialog.findViewById(R.id.noButton) as View
            yesView.setOnClickListener {
                dogs.removeAt(position)
                notifyDataSetChanged()
                dialog.dismiss()
            }
            noView.setOnClickListener { dialog.dismiss() }
            dialog.show()
        }


        holder.itemEdit.setOnClickListener{v: View ->
            val dialog = Dialog(v.context)
            dialog.setCancelable(true)
            dialog.setContentView(R.layout.edit_popup)
            val title = dialog.findViewById(R.id.titleLabel) as TextView
            var str = dogs.get(position).name
            str += "?"
            title.text = str
            val yesView = dialog.findViewById(R.id.yesButton) as View
            val noView = dialog.findViewById(R.id.noButton) as View
            yesView.setOnClickListener {
                val context = v.context
                val intent = Intent(context, EditActivity::class.java)
                intent.putExtra("dog", dogs[position])
                intent.putExtra("position", position)
                (context as Activity).startActivityForResult(intent, 5)
                notifyDataSetChanged()
                dialog.dismiss()
            }
            noView.setOnClickListener { dialog.dismiss() }
            dialog.show()
        }
    }



}