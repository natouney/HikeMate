'use client'

import { useState, useEffect } from 'react'
import { PlusCircle, Trash2, CheckCircle, Mountain, ChevronDown, ChevronUp } from 'lucide-react'
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Card, CardContent } from "@/components/ui/card"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"

type Item = {
  id: number
  name: string
  checked: boolean
  weight: number
  category: string
  quantity: number
}

type Category = {
  name: string
  items: Item[]
}

const defaultFoodMenu = [
  { name: 'Energy bar', weight: 50, quantity: 2 },
  { name: 'Trail mix', weight: 100, quantity: 1 },
  { name: 'Dried fruits', weight: 50, quantity: 1 },
  { name: 'Nuts', weight: 50, quantity: 1 },
  { name: 'Freeze-dried meal', weight: 150, quantity: 1 },
  { name: 'Instant oatmeal', weight: 40, quantity: 1 },
  { name: 'Protein powder', weight: 30, quantity: 1 },
  { name: 'Electrolyte tablets', weight: 10, quantity: 2 },
]

export default function HikeMateApp() {
  const [tripDetails, setTripDetails] = useState({
    departureTime: '',
    hungerLevel: 'medium',
    numberOfPeople: 1,
    numberOfDays: 1,
  })

  const [categories, setCategories] = useState<Category[]>([
    { name: 'Food', items: [] },
    { name: 'Hiking Gear', items: [] },
    { name: 'Clothing', items: [] },
    { name: 'Other', items: [] },
  ])

  const [newItem, setNewItem] = useState({ name: '', weight: 0, category: 'Other' })
  const [expandedCategory, setExpandedCategory] = useState<string | null>(null)

  useEffect(() => {
    updateFoodItems()
  }, [tripDetails.hungerLevel, tripDetails.numberOfDays, tripDetails.numberOfPeople])

  const updateFoodItems = () => {
    const hungerScaleFactor = {
      low: 0.8,
      medium: 1,
      high: 1.2,
    }[tripDetails.hungerLevel]

    const scaledFoodItems = defaultFoodMenu.map(item => ({
      ...item,
      id: Date.now() + Math.random(),
      checked: false, // Set to false by default
      category: 'Food',
      quantity: Math.round(item.quantity * hungerScaleFactor * tripDetails.numberOfDays * tripDetails.numberOfPeople),
    }))

    setCategories(prevCategories => {
      const updatedCategories = [...prevCategories]
      const foodCategoryIndex = updatedCategories.findIndex(c => c.name === 'Food')
      if (foodCategoryIndex !== -1) {
        updatedCategories[foodCategoryIndex].items = scaledFoodItems
      }
      return updatedCategories
    })
  }

  const addItem = () => {
    if (newItem.name.trim() !== '') {
      const categoryIndex = categories.findIndex(c => c.name === newItem.category)
      if (categoryIndex !== -1) {
        const updatedCategories = [...categories]
        updatedCategories[categoryIndex].items.push({
          id: Date.now(),
          name: newItem.name,
          checked: false,
          weight: newItem.weight,
          category: newItem.category,
          quantity: 1,
        })
        setCategories(updatedCategories)
        setNewItem({ name: '', weight: 0, category: 'Other' })
      }
    }
  }

  const toggleItem = (categoryName: string, id: number) => {
    const categoryIndex = categories.findIndex(c => c.name === categoryName)
    if (categoryIndex !== -1) {
      const updatedCategories = [...categories]
      const itemIndex = updatedCategories[categoryIndex].items.findIndex(item => item.id === id)
      if (itemIndex !== -1) {
        updatedCategories[categoryIndex].items[itemIndex].checked = !updatedCategories[categoryIndex].items[itemIndex].checked
        setCategories(updatedCategories)
      }
    }
  }

  const removeItem = (categoryName: string, id: number) => {
    const categoryIndex = categories.findIndex(c => c.name === categoryName)
    if (categoryIndex !== -1) {
      const updatedCategories = [...categories]
      updatedCategories[categoryIndex].items = updatedCategories[categoryIndex].items.filter(item => item.id !== id)
      setCategories(updatedCategories)
    }
  }

  const updateItemQuantity = (categoryName: string, id: number, newQuantity: number) => {
    const categoryIndex = categories.findIndex(c => c.name === categoryName)
    if (categoryIndex !== -1) {
      const updatedCategories = [...categories]
      const itemIndex = updatedCategories[categoryIndex].items.findIndex(item => item.id === id)
      if (itemIndex !== -1) {
        updatedCategories[categoryIndex].items[itemIndex].quantity = newQuantity
        setCategories(updatedCategories)
      }
    }
  }

  const calculateTotalWeight = () => {
    return categories.reduce((total, category) => 
      total + category.items.reduce((catTotal, item) => 
        catTotal + (item.checked ? item.weight * item.quantity : 0), 0
      ), 0
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-green-100 to-blue-100 flex flex-col">
      <header className="bg-green-600 text-white p-4 shadow-md">
        <div className="container mx-auto flex items-center justify-between">
          <h1 className="text-2xl font-bold flex items-center">
            <Mountain className="mr-2" /> HikeMate
          </h1>
          <p className="text-sm">Your Hiking Companion</p>
        </div>
      </header>

      <main className="flex-grow container mx-auto p-4 md:p-6 pb-20">
        <Card className="bg-white shadow-xl rounded-lg overflow-hidden mb-6">
          <CardContent className="p-6">
            <h2 className="text-2xl font-semibold mb-4">Trip Details</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label htmlFor="departureTime" className="block text-sm font-medium text-gray-700 mb-1">Departure Time</label>
                <Input
                  id="departureTime"
                  type="time"
                  value={tripDetails.departureTime}
                  onChange={(e) => setTripDetails({...tripDetails, departureTime: e.target.value})}
                  className="w-full"
                />
              </div>
              <div>
                <label htmlFor="hungerLevel" className="block text-sm font-medium text-gray-700 mb-1">Hunger Level</label>
                <Select onValueChange={(value) => setTripDetails({...tripDetails, hungerLevel: value})}>
                  <SelectTrigger id="hungerLevel">
                    <SelectValue placeholder="Select hunger level" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="low">Low</SelectItem>
                    <SelectItem value="medium">Medium</SelectItem>
                    <SelectItem value="high">High</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div>
                <label htmlFor="numberOfPeople" className="block text-sm font-medium text-gray-700 mb-1">Number of People</label>
                <Input
                  id="numberOfPeople"
                  type="number"
                  min="1"
                  value={tripDetails.numberOfPeople}
                  onChange={(e) => setTripDetails({...tripDetails, numberOfPeople: parseInt(e.target.value)})}
                  className="w-full"
                />
              </div>
              <div>
                <label htmlFor="numberOfDays" className="block text-sm font-medium text-gray-700 mb-1">Number of Days</label>
                <Input
                  id="numberOfDays"
                  type="number"
                  min="1"
                  value={tripDetails.numberOfDays}
                  onChange={(e) => setTripDetails({...tripDetails, numberOfDays: parseInt(e.target.value)})}
                  className="w-full"
                />
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="bg-white shadow-xl rounded-lg overflow-hidden">
          <CardContent className="p-6">
            <h2 className="text-2xl font-semibold mb-4">Packing List</h2>
            <div className="flex flex-wrap mb-4 gap-2">
              <Input
                type="text"
                placeholder="Add new item..."
                value={newItem.name}
                onChange={(e) => setNewItem({...newItem, name: e.target.value})}
                className="flex-grow"
              />
              <Input
                type="number"
                placeholder="Weight (g)"
                value={newItem.weight || ''}
                onChange={(e) => setNewItem({...newItem, weight: parseFloat(e.target.value)})}
                className="w-24"
              />
              <Select onValueChange={(value) => setNewItem({...newItem, category: value})}>
                <SelectTrigger className="w-40">
                  <SelectValue placeholder="Category" />
                </SelectTrigger>
                <SelectContent>
                  {categories.map((category) => (
                    <SelectItem key={category.name} value={category.name}>{category.name}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <Button onClick={addItem}>
                <PlusCircle className="mr-2 h-4 w-4" /> Add
              </Button>
            </div>
            {categories.map((category) => (
              <div key={category.name} className="mb-4">
                <div
                  className="flex items-center justify-between bg-gray-100 p-3 rounded-md cursor-pointer"
                  onClick={() => setExpandedCategory(expandedCategory === category.name ? null : category.name)}
                >
                  <h3 className="text-lg font-semibold">{category.name}</h3>
                  {expandedCategory === category.name ? <ChevronUp /> : <ChevronDown />}
                </div>
                {expandedCategory === category.name && (
                  <ul className="space-y-2 mt-2">
                    {category.items.map(item => (
                      <li key={item.id} className="flex items-center justify-between bg-gray-50 p-3 rounded-md">
                        <div className="flex items-center">
                          <Button
                            variant="ghost"
                            size="sm"
                            className={`mr-2 ${item.checked ? 'text-green-500' : 'text-gray-400'}`}
                            onClick={() => toggleItem(category.name, item.id)}
                          >
                            <CheckCircle className="h-5 w-5" />
                          </Button>
                          <span className={item.checked ? 'line-through text-gray-500' : ''}>{item.name} ({item.weight}g)</span>
                        </div>
                        <div className="flex items-center">
                          <Input
                            type="number"
                            min="1"
                            value={item.quantity}
                            onChange={(e) => updateItemQuantity(category.name, item.id, parseInt(e.target.value))}
                            className="w-16 mr-2"
                          />
                          <Button variant="ghost" size="sm" onClick={() => removeItem(category.name, item.id)}>
                            <Trash2 className="h-5 w-5 text-red-500" />
                          </Button>
                        </div>
                      </li>
                    ))}
                  </ul>
                )}
              </div>
            ))}
          </CardContent>
        </Card>
      </main>

      <footer className="fixed bottom-0 left-0 right-0 bg-green-600 text-white p-4 shadow-md">
        <div className="container mx-auto flex justify-between items-center">
          <p className="text-sm">© 2023 HikeMate. Happy Hiking!</p>
          <p className="text-xl font-semibold">Total Weight: {calculateTotalWeight()}g</p>
        </div>
      </footer>
    </div>
  )
}