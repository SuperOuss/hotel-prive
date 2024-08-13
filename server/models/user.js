import _sequelize from "sequelize";
const { Model, Sequelize } = _sequelize;

export default class user extends Model {
  static init(sequelize, DataTypes) {
    return super.init({
      id: {
        autoIncrement: true,
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true
      },
      first_name: {
        type: DataTypes.STRING(100),
        allowNull: false
      },
      last_name: {
        type: DataTypes.STRING(100),        
        allowNull: false
      },
      email: {
        type: DataTypes.STRING(100),
        allowNull: false
      },
      countryCode: {
        type: DataTypes.STRING(20),
        allowNull: false
      },
      phone: {
        type: DataTypes.INTEGER,
        allowNull: false
      },
      password: {
        type: DataTypes.STRING(100),
        allowNull: false
      },
      fav_hotels: {
        type: DataTypes.JSON,
        allowNull: true
      },
      fav_locations: {
        type: DataTypes.JSON,
        allowNull: true
      },      
      isDeactivated: {
        type: DataTypes.BOOLEAN,
        allowNull: true,
      }
    }, {
      sequelize,
      tableName: 'user',
      timestamps: false,
      indexes: [
        {
          name: "PRIMARY",
          unique: true,
          using: "BTREE",
          fields: [
            { name: "id" },
          ]
        }
      ]
    });
  }
/*   static associate(models) {
    this.hasMany(models.comments, {
      foreignKey: 'userId',
      as: 'comments'
    });
    this.hasMany(models.location, {
      foreignKey: 'userId',
      as: 'location'
    });
    this.belongsTo(models.organisation, {
      foreignKey: 'companyId',
      as: 'company'
    });
    this.hasMany(models.statusChangeLog, {
      foreignKey: 'userId',
      as: 'status_change_log'
    });
  } */
} 
