namespace :data do

  desc 'Seed tribunals'
  task seed_tribunals: :environment do
    Tribunal.create([
      {name:'Immigration and Aslyum Chamber' , code:'utiac'},
      {name:'First Tier Tribunal ' , code:'ftt' },
      {name:'Administrative Appeals Chamber' , code:'aac'},
      {name:'Employment Appeals Tribunal' , code:'eat'}
    ])
  end

end