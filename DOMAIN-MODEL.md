League 
# rails g model league name:string type:string address_id:integer description:text status:string
has_many :seasons
has_many :players

    Season 
    # rails g model season name:string start_at:date ends_at:date league:references status:string
    belongs_to :league
    has_many :divisions

        Division 
        # rails g model division season:references name:string max_teams:integer description:text status:string 
        belongs_to :season
        has_many :sports_teams

            SportsTeam 
            # rails g model sports_team name:string description:text division:references logo_url:string primary_color:string secondary_color:string player:references status:string 
            belongs_to :division
            has_many :players, through: :team_player_links
            has_many :team_player_links

                TeamPlayerLink
                # rails g model team_player_link sports_team:references player:references 
                belongs_to :sports_team
                belongs_to :player 

                Player
                # rails g model player first_name:string last_name:string date_of_birth:date height:integer weight:integer gender:string email:string phone_number:string profile_photo_url:string league:references 
                has_many :team_player_links
                has_many :sports_teams, through: :team_player_links

                GameTeamLink
                # rails g model game_team_link sports_team:references game:references 
                belongs_to :sports_team 
                belongs_to :game

                Game
                # rails g model game starts_at:date ends_at:date address:references
                belongs_to :address
                has_many :game_team_links
                has_many :sports_teams, through: :game_team_links